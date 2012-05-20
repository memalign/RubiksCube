
require 'RubiksCube'

class RubiksSimpleSolver
    def initialize(cube)
        @cube = cube
        @moves = []
    end

    def performTransform(move)
        puts "Performing #{move}"
        move.split(',').each { |t|
            @moves << t
            @cube.performTransform(t)
        }
    end

    def solve

        # Rotate white to be the top
        rotateWhiteToTop
        puts "After rotating white to top:\n#{@cube.to_s}"

        # Solve for the white corners
        solveAllTopCorners
        puts "After solving the top corners:\n#{@cube.to_s}"

        # Solve for the white edges
        solveAllTopEdges

        # Yay! The top is now solved :)

        # Solve for the middle edges
        solveAllMiddleEdges

        # Time to solve the bottom
        performTransform("z,z") # put the bottom on the top

        # Get the bottom corners in their ultimate positions though their orientation won't be solved yet
        positionBottomCorners

        puts "Bottom corners should be positioned: #{@cube}"

        # Rotate the corners into the correct orientations
        orientBottomCorners

        # Rotate the edges to have yellow up
        orientBottomEdges

        # Move the edges into their correct positions
        positionBottomEdges
    end

    def positionBottomEdges
        leftFace = @cube.findCube(-1, 0, 0)
        backFace = @cube.findCube(0, 0, -1)
        rightFace = @cube.findCube(1, 0, 0)
        frontFace = @cube.findCube(0, 0, 1)

        unsolvedEdges = @cube.findCubesMatchingTest { |subcube|
            isEdge = subcube.isEdge && (subcube.y == 1)
            correctlyPositioned = (((subcube.z == -1) && (subcube.back == backFace.back)) || (subcube.z != -1))
            correctlyPositioned = correctlyPositioned && (((subcube.z == 1) && (subcube.front == frontFace.front)) || (subcube.z != 1))
            correctlyPositioned = correctlyPositioned && (((subcube.x == -1) && (subcube.left == leftFace.left)) || (subcube.x != -1))
            correctlyPositioned = correctlyPositioned && (((subcube.x == 1) && (subcube.right == rightFace.right)) || (subcube.x != 1))
            isEdge && !correctlyPositioned
        }

        puts "Found unsolved edges #{unsolvedEdges}"
        if (unsolvedEdges.count == 0)
            puts "All edges are solved!"
            return true
        end
        # The possibilities here are unsolvedEdges.count == 0,3,4
        # Try to get the solved edge facing front
        (1..3).each { |i|
            # Is the edge toward us in the correct position?
            if (@cube.findCube(0,1,1).front == @cube.findCube(0,0,1).front)
                break
            end
            performTransform("y")
        }

        puts "Solved edge should be towards us: #{@cube}"

        # Pick which direction to turn the top
        # If the edge on the left matches the back, perform U
        trans = "U'"
        if (@cube.findCube(-1,1,0).left == @cube.findCube(0,0,-1).back)
            trans = "U"
        end

        performTransform("B,B,#{trans},L',R,x',U,U,L,R',x,#{trans},B,B")

        return positionBottomEdges
    end

    def orientBottomEdges
        # There are a few options here, we can have two or four non-yellows up
        unsolvedEdges = @cube.findCubesMatchingTest { |subcube|
            # Top edge that doesn't have yellow up
            subcube.isEdge && (subcube.y == 1) && (subcube.up != RubiksColor::YELLOW)
        }

        if (unsolvedEdges.count == 0)
            puts "All edges are oriented correctly :)"
            puts "#{@cube}"
            return true
        else # 2 or 4
            adjacentEdges = false
            while (true)
                adjacentEdges = ((@cube.findCube(0,1,-1).up != RubiksColor::YELLOW) && (@cube.findCube(1,1,0).up != RubiksColor::YELLOW))
                acrossEdges = ((@cube.findCube(0,1,-1).up != RubiksColor::YELLOW) && (@cube.findCube(0,1,1).up != RubiksColor::YELLOW))
                if (adjacentEdges || acrossEdges)
                    break
                end
                performTransform("y")
            end

            if (adjacentEdges)
                performTransform("L,R',x,U',L',R,x',U',U',L,R',x,U',L',R,x'")
            else # across from each other
                puts "Cube #{@cube}"
                performTransform("L,R',x,U',L,R',x,U',L,R',x,U',U',L',R,x',U',L',R,x',U',L',R,x',U',U'")
            end
        end
        return orientBottomEdges
    end

    def countYellowUps(corners)
        numYellowUp = 0
        corners.each { |subcube|
            if (subcube.up == RubiksColor::YELLOW)
                numYellowUp += 1
            end
        }
        numYellowUp
    end

    def orientBottomCorners
        corners = @cube.findCubesMatchingTest { |subcube|
            subcube.isCorner && subcube.y == 1
        }

        puts "Found corners #{corners}"

        numYellowUp = countYellowUps(corners)
        puts "Number of corners with yellow up #{numYellowUp}"
        if (numYellowUp == 4)
            puts "All four corners are oriented correctly :)"
            return
        elsif (numYellowUp == 1)
            # Find this corner, get it into (1,1,1)
            while (!(@cube.findCube(1,1,1).up == RubiksColor::YELLOW))
                performTransform("y")
            end
            # Perform the transform until all four are up
            while (countYellowUps(corners) != 4)
                performTransform("L',U',L,U',L',U',U',L,U',U'")
            end
        else
            # Rotate cube until the one in (1,1,1) has yellow out to the right
            while (!(@cube.findCube(1,1,1).right == RubiksColor::YELLOW))
                performTransform("y")
            end

            # Perform the transform until 1 is up
            while (countYellowUps(corners) != 1)
                performTransform("L',U',L,U',L',U',U',L,U',U'")
            end

            # Rotate the cube until that one is in (1,1,1)
            while (!(@cube.findCube(1,1,1).up == RubiksColor::YELLOW))
                performTransform("y")
            end
            # Perform the transform until all four are up
            while (countYellowUps(corners) != 4)
                performTransform("L',U',L,U',L',U',U',L,U',U'")
            end
        end
    end

    def positionBottomCorners
        leftFace = @cube.findCube(-1, 0, 0)
        backFace = @cube.findCube(0, 0, -1)
        rightFace = @cube.findCube(1, 0, 0)
        frontFace = @cube.findCube(0, 0, 1)

        # There are at least two corners that will be in the correct positions, find them
        subcubes = []
        begin
            performTransform("U")
            subcubes = @cube.findCubesMatchingTest { |subcube|
                positionedCorrectly = (subcube.y == 1) && subcube.isCorner
                positionedCorrectly = positionedCorrectly && ((subcube.x == 1 && subcube.hasColor(rightFace.right)) || subcube.x != 1)
                positionedCorrectly = positionedCorrectly && ((subcube.x == -1 && subcube.hasColor(leftFace.left)) || subcube.x != -1)
                positionedCorrectly = positionedCorrectly && ((subcube.z == 1 && subcube.hasColor(frontFace.front)) || subcube.z != 1)
                positionedCorrectly = positionedCorrectly && ((subcube.z == -1 && subcube.hasColor(backFace.back)) || subcube.z != -1)
                positionedCorrectly
            }
        end while (subcubes.count < 2)

        puts "Found correctly positioned subcubes #{subcubes} in #{@cube}"

        if (subcubes.count == 4)
            puts "They're all solved, yay!"
            return
        end

        # If they're adjacent, we want both of them at the front. Try to get two of these in the front.
        areDiagonal = true
        (1..4).each { |i|
            numFront = 0
            subcubes.each { |subcube|
                if (subcube.z == 1)
                    numFront += 1
                end
            }

            if (numFront == 2)
                areDiagonal = false
                break
            end

            performTransform("y")
        }

        performTransform("L',U',L,F,U'")
        if (areDiagonal)
            performTransform("U'")
        end
        performTransform("F',L',U,L")
        
        frontFace = @cube.findCube(0,0,1)
        rightFace = @cube.findCube(1,0,0)
        # Rotate Up until positioned correctly
        while (!(@cube.findCube(1,1,1).hasColor(frontFace.front) && @cube.findCube(1,1,1).hasColor(rightFace.right)))
            performTransform("U")
        end
    end

    def solveAllMiddleEdges
        solveMiddleEdge && solveMiddleEdge && solveMiddleEdge && solveMiddleEdge
    end

    def solveMiddleEdge
        # Find an unsolved edge
        leftFace = @cube.findCube(-1, 0, 0)
        backFace = @cube.findCube(0, 0, -1)
        rightFace = @cube.findCube(1, 0, 0)
        frontFace = @cube.findCube(0, 0, 1)
 
        subcubes = @cube.findCubesMatchingTest { |subcube|
            isMiddleEdge = subcube.isEdge && !subcube.hasColor(RubiksColor::YELLOW) && !subcube.hasColor(RubiksColor::WHITE)
            correctlyPlaced = (subcube.hasCoordinates(1,0,1) && subcube.front == frontFace.front && subcube.right == rightFace.right)
            correctlyPlaced = correctlyPlaced || (subcube.hasCoordinates(-1,0,1) && subcube.front == frontFace.front && subcube.left == leftFace.left)
            correctlyPlaced = correctlyPlaced || (subcube.hasCoordinates(-1,0,-1) && subcube.left == leftFace.left && subcube.back == backFace.back)
            correctlyPlaced = correctlyPlaced || (subcube.hasCoordinates(1,0,-1) && subcube.right == rightFace.right && subcube.back == backFace.back)
            
            isMiddleEdge && !correctlyPlaced
        }
        puts "Found unsolved middle edges #{subcubes}"
        
        # if there are any, choose one, solve it
        subcube = subcubes[0]
        if (subcube.nil?)
            return nil
        end

        # If the edge is in the middle slice, move it to the bottom
        if (subcube.y == 0)
            # Get it to (1,0,1)
            while (!subcube.hasCoordinates(1,0,1))
                performTransform("y")
            end

            performTransform("R',D,R,D,F,D',F'")
        end

        # Get our cube across from the face with its bottom's color
        while (!@cube.findCube(-subcube.x,0,-subcube.z).hasColor(subcube.down))
            performTransform("D")
        end

        # Rotate the cube until we're either on the right or left with our other color on the front
        while (!((subcube.x == 1 || subcube.x == -1) && subcube.hasColor(@cube.findCube(0,0,1).front)))
            performTransform("y")
        end

        # We're either on the left or the right
        if (subcube.x == 1)
            performTransform("L,D',L',D',F',D,F")
        else
            performTransform("R',D,R,D,F,D',F'")
        end

        return subcube
    end

    def solveAllTopEdges
        solveTopEdge && solveTopEdge && solveTopEdge && solveTopEdge
    end

    def solveTopEdge
        # Find an unsolved edge
        leftFace = @cube.findCube(-1, 0, 0)
        backFace = @cube.findCube(0, 0, -1)
        rightFace = @cube.findCube(1, 0, 0)
        frontFace = @cube.findCube(0, 0, 1)
 
        subcubes = @cube.findCubesMatchingTest { |subcube|
            isWhiteEdge = subcube.isEdge && subcube.hasColor(RubiksColor::WHITE)
            correctlyPlaced = (subcube.x == 1) && (subcube.right == rightFace.right)
            correctlyPlaced = correctlyPlaced || (subcube.x == -1) && (subcube.left == leftFace.left)
            correctlyPlaced = correctlyPlaced || (subcube.z == 1) && (subcube.front == frontFace.front)
            correctlyPlaced = correctlyPlaced || (subcube.z == -1) && (subcube.back == backFace.back)
            correctlyPlaced = correctlyPlaced && (subcube.up == RubiksColor::WHITE)

            isWhiteEdge && !correctlyPlaced
        }
        puts "Found unsolved up edges #{subcubes}"
        
        # if there are any, choose one, solve it
        subcube = subcubes[0]
        if (subcube.nil?)
            return nil
        end

        # Get the cube out of the top if necessary
        if (subcube.y == 1)
            # Rotate the cube to (1,1,0)
            while (!subcube.hasCoordinates(1,1,0))
                performTransform("y")
            end
            # Get it out of the top
            performTransform("R,U,D',F,U',D,R,R")
        end

        # Get its destination to (1,1,0)
        transformDestinationForCubeToPosition("y",subcube,1,1,0)

        # The cube itself can be in two orientations relative to its final position if it's in the middle slice
        if (subcube.y == 0)
            while (!(subcube.left == RubiksColor::WHITE && subcube.hasCoordinates(-1,0,1)) && !(subcube.left == RubiksColor::WHITE && subcube.hasCoordinates(-1,0,-1)))
                # Rotate the middle slice
                performTransform("U,D',y'")
            end

            # Put the edge into its place
            if (subcube.z == 1)
                performTransform("R',U,D',y',R")
            else
                performTransform("R,U',D,y,R'")
            end
        else

            puts "Subcube should be in the bottom #{subcube} #{@cube}"
            # This subcube is in the bottom
            # Get it under its target spot
            while (!subcube.hasCoordinates(1,-1,0))
                performTransform("D")
            end

            if (subcube.down == RubiksColor::WHITE)
                performTransform("R',U,D',y',R,R,U',D,y,R'")
            else
                performTransform("R',U',D,y,R")
            end
        end

        # Rotate the top to match the centers
        leftFace = @cube.findCube(-1, 0, 0)
        while (@cube.findCube(-1, 1, 1).left != leftFace.left)
            performTransform("U")
        end

        puts "Cubeasdf: #{@cube}"
        return subcube
    end

    def solveAllTopCorners
        solveTopCorner && solveTopCorner && solveTopCorner && solveTopCorner
    end

    def solveTopCorner
        # Find an unsolved corner
        leftFace = @cube.findCube(-1, 0, 0)
        backFace = @cube.findCube(0, 0, -1)
        rightFace = @cube.findCube(1, 0, 0)
        frontFace = @cube.findCube(0, 0, 1)
 
        subcubes = @cube.findCubesMatchingTest { |subcube|
            # is a white corner piece
            isWhiteCorner = subcube.isCorner && subcube.hasColor(RubiksColor::WHITE)
            # is not in the right position/orientation
            correctlyPlaced = true
            if (isWhiteCorner)
                # what are the non-top colors? do they match the respective sides
                correctlyPlaced = correctlyPlaced && (subcube.y == 1)
                correctlyPlaced = correctlyPlaced && (subcube.up == RubiksColor::WHITE)
                
                correctOrientation = (subcube.x == -1) && (subcube.z == -1) && (leftFace.left == subcube.left) && (backFace.back == subcube.back)
                correctOrientation = correctOrientation || (subcube.x == 1) && (subcube.z == -1) && (rightFace.right == subcube.right) && (backFace.back == subcube.back)
                correctOrientation = correctOrientation || (subcube.x == 1) && (subcube.z == 1) && (frontFace.front == subcube.front) && (rightFace.right == subcube.right)
                correctOrientation = correctOrientation || (subcube.x == -1) && (subcube.z == 1) && (frontFace.front == subcube.front) && (leftFace.left == subcube.left)
                correctlyPlaced = correctlyPlaced && correctOrientation
            end

            isWhiteCorner && !correctlyPlaced
        }
        puts "Found unsolved top corners #{subcubes}"
        
        # if there are any, choose one, solve it
        subcube = subcubes[0]
        if (subcube.nil?)
            return nil
        end
        
        # if it's in the top, get it out of there
        if (subcube.y == 1)
            # Rotate the whole cube around the y axis until it's in 1,1 for simplicity
            yPrimeTransforms = ""
            comma = ""
            while (!(subcube.x == 1 && subcube.z == 1))
                performTransform("y")
                yPrimeTransforms << "#{comma}y'"
                comma = ","
            end

            performTransform("F,D,F'")
            performTransform(yPrimeTransforms) # This isn't necessary if we don't care about restoring the original orientation of the cube
        end

        puts "Cube after moving corner out of top:\n#{@cube.to_s}"
        # if white is on the bottom, get it on a side
        if (subcube.down == RubiksColor::WHITE)
            # Get the destination of this cube into (1,1,1)
            undoTransform = transformDestinationForCubeToPosition("y",subcube,1,1,1)

            # put this cube into (1,-1,-1)
            while (!subcube.hasCoordinates(1,-1,-1))
                performTransform("D")
            end

            performTransform("F,D,D,F'") # this gets the white face off of the bottom of this subcube and leaves it at (1,-1,1)
            performTransform(undoTransform) # restores the orientation of the cube
        end

        # Get the destination of this cube into (1,1,1)
        undoTransform = transformDestinationForCubeToPosition("y",subcube,1,1,1)
        # Get this cube into position
        # There are two places we might end up:
        #   (1,-1,-1) with white on the back
        #   (-1,-1,1) with white on the left
        while (!
               ((subcube.hasCoordinates(1,-1,-1) && (subcube.back == RubiksColor::WHITE)) ||
                (subcube.hasCoordinates(-1,-1,1) && (subcube.left == RubiksColor::WHITE))))
            performTransform("D")
        end

        # Move this cube into its position
        if (subcube.hasCoordinates(1,-1,-1))
            performTransform("F,D',F'")
        else # (-1,-1,1)
            performTransform("R',D,R")
        end

        return subcube
    end

    # Returns the "undo" transform that puts the cube back to its original orientation
    def transformDestinationForCubeToPosition(transform, subcube, x, y, z)
        # What are the relevant faces?
        useRight = (x == 1)
        useLeft = (x == -1)
        useTop = (y == 1)
        useDown = (y == -1)
        useFront = (z == 1)
        useBack = (z == -1)

        correctlyPositioned = false

        undoTransform = ""
        comma = ""
        while (!correctlyPositioned)
            # If I was really clever, I'd inline these lookups below to avoid unnecessary ones
            rightFace = @cube.findCube(1, 0, 0)
            leftFace = @cube.findCube(-1, 0, 0)
            topFace = @cube.findCube(0, 1, 0)
            downFace = @cube.findCube(0, -1, 0)
            frontFace = @cube.findCube(0, 0, 1)
            backFace = @cube.findCube(0, 0, -1)

            correctlyPositioned = (!useRight || subcube.hasColor(rightFace.right)) &&
                                  (!useLeft || subcube.hasColor(leftFace.left)) &&
                                  (!useTop || subcube.hasColor(topFace.up)) &&
                                  (!useDown || subcube.hasColor(downFace.down)) &&
                                  (!useFront || subcube.hasColor(frontFace.front)) &&
                                  (!useBack || subcube.hasColor(backFace.back))

            if (correctlyPositioned)
                break
            end

            performTransform(transform)
            undoTransform << "#{comma}#{transform}'"
            comma = ","
        end

        return undoTransform
    end

    def rotateWhiteToTop
        puts "Rotating white to top"
        puts "Looking for white center cube"
        subcubes = @cube.findCubesMatchingTest { |subcube|
            subcube.isCenterOfFace && subcube.hasColor(RubiksColor::WHITE)
        }
        puts "Found subcubes: #{subcubes}"

        whiteCenter = subcubes[0] # There should only be one!
        if (whiteCenter.z != 0)
            onFront = (whiteCenter.z == 1) # otherwise on back
            puts "WhiteCenter is on the #{onFront ? "front" : "back"}"
            transform = onFront ? "x" : "x'"
            performTransform(transform)
        elsif (whiteCenter.y != 0)
            onTop = (whiteCenter.y == 1) # otherwise on bottom
            if (onTop)
                puts "WhiteCenter is already at the top, nothing to do here."
            else
                puts "WhiteCenter is on the bottom"
                performTransform("x,x")
            end
        elsif (whiteCenter.x != 0)
            onLeft = (whiteCenter.x == -1) # otherwise on right
            puts "WhiteCenter is on the #{onLeft ? "left" : "right"}"
            transform = onLeft ? "z" : "z'"
            performTransform(transform)
        end
    end
end
