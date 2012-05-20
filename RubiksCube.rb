#!/usr/bin/ruby

require 'RubiksSubcube'

class RubiksCube

    # A RubiksCube is made up of 9+8(+1 entirely hidden)+9 subcubes
    def initialize
        
        @subcubes = Array.new
        

# Cube looks like this:
        #     y+ z-
        #      |/
        #x- ---|--- x+
        #     /|
        #   z+ y-
        #
        #   / a/b /c /|
        #   -----------
        #  / d/ e/ f/ | 
        #  ----------
        # / g/ h/ i/ |
        # ----------/
        # |g |h |i | |
        # ----------/
        # |  |  |  | |
        # ----------/
        # |  |  |  | |
        # ----------/


        #let's create these subcubes with white on top, green facing us, red on the right
        # Start with (x,y,z)=(-1,1,-1)
        # a
        @subcubes << RubiksSubcube.new(-1, 1, -1,
                                       RubiksColor::WHITE, RubiksColor::HIDDEN, RubiksColor::BLUE, RubiksColor::ORANGE, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        # b
        @subcubes << RubiksSubcube.new(0, 1, -1,
                                       RubiksColor::WHITE, RubiksColor::HIDDEN, RubiksColor::BLUE, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        # c
        @subcubes << RubiksSubcube.new(1, 1, -1,
                                       RubiksColor::WHITE, RubiksColor::HIDDEN, RubiksColor::BLUE, RubiksColor::HIDDEN, RubiksColor::RED, RubiksColor::HIDDEN)

        # d
        @subcubes << RubiksSubcube.new(-1, 1, 0, 
                                       RubiksColor::WHITE, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::ORANGE, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        # e
        @subcubes << RubiksSubcube.new(0, 1, 0,
                                       RubiksColor::WHITE, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        # f
        @subcubes << RubiksSubcube.new(1, 1, 0,
                                       RubiksColor::WHITE, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::RED, RubiksColor::HIDDEN)

        # g
        @subcubes << RubiksSubcube.new(-1, 1, 1, 
                                       RubiksColor::WHITE, RubiksColor::GREEN, RubiksColor::HIDDEN, RubiksColor::ORANGE, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        # h
        @subcubes << RubiksSubcube.new(0, 1, 1,
                                       RubiksColor::WHITE, RubiksColor::GREEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        # i
        @subcubes << RubiksSubcube.new(1, 1, 1,
                                       RubiksColor::WHITE, RubiksColor::GREEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::RED, RubiksColor::HIDDEN)

    #(top, front, back, left, right, down)
        # Next slice down
        @subcubes << RubiksSubcube.new(-1, 0, -1,
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::BLUE, RubiksColor::ORANGE, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        @subcubes << RubiksSubcube.new(0, 0, -1,
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::BLUE, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        @subcubes << RubiksSubcube.new(1, 0, -1,
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::BLUE, RubiksColor::HIDDEN, RubiksColor::RED, RubiksColor::HIDDEN)
        @subcubes << RubiksSubcube.new(-1, 0, 0, 
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::ORANGE, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        @subcubes << RubiksSubcube.new(0, 0, 0,
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        @subcubes << RubiksSubcube.new(1, 0, 0,
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::RED, RubiksColor::HIDDEN)
        @subcubes << RubiksSubcube.new(-1, 0, 1, 
                                       RubiksColor::HIDDEN, RubiksColor::GREEN, RubiksColor::HIDDEN, RubiksColor::ORANGE, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        @subcubes << RubiksSubcube.new(0, 0, 1,
                                       RubiksColor::HIDDEN, RubiksColor::GREEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN)
        @subcubes << RubiksSubcube.new(1, 0, 1,
                                       RubiksColor::HIDDEN, RubiksColor::GREEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::RED, RubiksColor::HIDDEN)

        # Next slice down
        @subcubes << RubiksSubcube.new(-1, -1, -1,
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::BLUE, RubiksColor::ORANGE, RubiksColor::HIDDEN, RubiksColor::YELLOW)
        @subcubes << RubiksSubcube.new(0, -1, -1,
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::BLUE, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::YELLOW)
        @subcubes << RubiksSubcube.new(1, -1, -1,
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::BLUE, RubiksColor::HIDDEN, RubiksColor::RED, RubiksColor::YELLOW)
        @subcubes << RubiksSubcube.new(-1, -1, 0, 
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::ORANGE, RubiksColor::HIDDEN, RubiksColor::YELLOW)
        @subcubes << RubiksSubcube.new(0, -1, 0,
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::YELLOW)
        @subcubes << RubiksSubcube.new(1, -1, 0,
                                       RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::RED, RubiksColor::YELLOW)
        @subcubes << RubiksSubcube.new(-1, -1, 1, 
                                       RubiksColor::HIDDEN, RubiksColor::GREEN, RubiksColor::HIDDEN, RubiksColor::ORANGE, RubiksColor::HIDDEN, RubiksColor::YELLOW)
        @subcubes << RubiksSubcube.new(0, -1, 1,
                                       RubiksColor::HIDDEN, RubiksColor::GREEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::YELLOW)
        @subcubes << RubiksSubcube.new(1, -1, 1,
                                       RubiksColor::HIDDEN, RubiksColor::GREEN, RubiksColor::HIDDEN, RubiksColor::HIDDEN, RubiksColor::RED, RubiksColor::YELLOW)
    end

    def printCube 
       puts to_s 
    end

    def to_s
        ret = ""

        ret << "top:\n" # y = 1
        (-1..1).each { |z|
            (-1..1).each { |x|
                #puts "x y z = #{x} 1 #{z}"
                ret << findCube(x, 1, z).up.to_s
            }
            ret << "\n"
        }

        ret << "left:\n" # x = -1
        [1,0,-1].each { |y|
            (-1..1).each { |z|
                ret << findCube(-1, y, z).left.to_s
            }
            ret << "\n"
        }

        ret << "right:\n" # x = 1
        [1,0,-1].each { |y|
            [1,0,-1].each { |z|
                ret << findCube(1, y, z).right.to_s
            }
            ret << "\n"
        }

        ret << "front:\n" # z = 1
        [1,0,-1].each { |y|
            (-1..1).each { |x|
                ret << findCube(x, y, 1).front.to_s
            }
            ret << "\n"
        }       

        ret << "back:\n" # z = -1
        [1,0,-1].each { |y|
            [1,0,-1].each { |x|
                ret << findCube(x, y, -1).back.to_s
            }
            ret << "\n"
        }

        ret << "down:\n" # y = -1
        (-1..1).each { |z|
            [1,0,-1].each { |x|
                ret << findCube(x, -1, z).down.to_s
            }
            ret << "\n"
        }

        return ret
    end

    def findCube(x, y, z)
        # This could be better...
        @subcubes.each { |subcube|
            if (subcube.hasCoordinates(x, y, z))
                return subcube
            end
        }
        return nil
    end


    # Moves
    # Move notation from http://en.wikipedia.org/wiki/Rubik%27s_Cube#Move_notation
    # http://www.cubewhiz.com/notationnj.php  Helpful pictures
    ##F (Front): the side currently facing the solver
    ##B (Back): the side opposite the front
    ##U (Up): the side above or on top of the front side
    ##D (Down): the side opposite the top, underneath the Cube
    ##L (Left): the side directly to the left of the front
    ##R (Right): the side directly to the right of the front
    #f (ƒ on wiki) (Front two layers): the side facing the solver and the corresponding middle layer
    #b (Back two layers): the side opposite the front and the corresponding middle layer
    #u (Up two layers) : the top side and the corresponding middle layer
    #d (Down two layers) : the bottom layer and the corresponding middle layer
    #l (Left two layers) : the side to the left of the front and the corresponding middle layer
    #r (Right two layers) : the side to the right of the front and the corresponding middle layer
    #x (rotate): rotate the entire Cube on R
    #y (rotate): rotate the entire Cube on U
    #z (rotate): rotate the entire Cube on F

    # Some of these are aggregate moves
    # F means rotate front clockwise, F' means rotate front ccw
    # FF could be represented as F2 (should I support this?)
    # B means rotate the back clockwise (rotate the back clockwise as if you were looking at it)
    def performTransform(symbol)
        cw = true
        axis = nil
        testBlock = nil
        case symbol
        when "F"
            # The front face is where z=1
            # This is rotating the cubes with z=1 by 90 degrees clockwise around the z axis
            testBlock = lambda { |subcube| subcube.z == 1 }
            cw = true
            axis = :z
        when "F'"
            # The front face is where z=1
            # This is rotating the cubes with z=1 by 90 degrees ccw around the z axis
            testBlock = lambda { |subcube| subcube.z == 1 }
            cw = false 
            axis = :z
         when "B"
             testBlock = lambda { |subcube| subcube.z == -1 }
             cw = false
             axis = :z
         when "B'"
             testBlock = lambda { |subcube| subcube.z == -1 }
             cw = true 
             axis = :z
         when "U"
             testBlock = lambda { |subcube| subcube.y == 1 }
             cw = true
             axis = :y
         when "U'"
             testBlock = lambda { |subcube| subcube.y == 1 }
             cw = false
             axis = :y
         when "D"
             testBlock = lambda { |subcube| subcube.y == -1 }
             cw = false
             axis = :y
         when "D'"
             testBlock = lambda { |subcube| subcube.y == -1 }
             cw = true 
             axis = :y
         when "R"
             testBlock = lambda { |subcube| subcube.x == 1 }
             cw = true 
             axis = :x
         when "R'"
             testBlock = lambda { |subcube| subcube.x == 1 }
             cw = false 
             axis = :x
         when "L"
             testBlock = lambda { |subcube| subcube.x == -1 }
             cw = false
             axis = :x
         when "L'"
             testBlock = lambda { |subcube| subcube.x == -1 }
             cw = true
             axis = :x
         when "x"
             testBlock = lambda { |subcube| true }
             cw = true
             axis = :x
         when "y"
             testBlock = lambda { |subcube| true }
             cw = true
             axis = :y
         when "z"
             testBlock = lambda { |subcube| true }
             cw = true
             axis = :z
         when "x'"
             testBlock = lambda { |subcube| true }
             cw = false
             axis = :x
         when "y'"
             testBlock = lambda { |subcube| true }
             cw = false
             axis = :y
         when "z'"
             testBlock = lambda { |subcube| true }
             cw = false
             axis = :z
         else
            puts "Unknown transform symbol: #{symbol}"
            return
        end

        @subcubes.each { |subcube|
            if (testBlock.call(subcube))
                #puts "Transforming"
                subcube.rotate(axis, cw)
            end
        }
    end

    def findCubesMatchingTest(&test)
        vals = []
        @subcubes.each { |subcube|
            if (test.call(subcube))
                vals << subcube
            end
        }
        vals
    end

    def isSolved
        isSolved = true

        # Check the top
        topColor = findCube(0,1,0).up
        [-1,0,1].each { |x|
            [-1,0,1].each { |z|
                isSolved = isSolved && (topColor == findCube(x, 1, z).up)
            }
        }

        # Check the left
        leftColor = findCube(-1,0,0).left
        [-1,0,1].each { |y|
            [-1,0,1].each { |z|
                isSolved = isSolved && (leftColor == findCube(-1, y, z).left)
            }
        }

        # Check the right
        rightColor = findCube(1,0,0).right
        [-1,0,1].each { |y|
            [-1,0,1].each { |z|
                isSolved = isSolved && (rightColor == findCube(1, y, z).right)
            }
        }

        # Check the front
        frontColor = findCube(0,0,1).front
        [-1,0,1].each { |y|
            [-1,0,1].each { |x|
                isSolved = isSolved && (frontColor == findCube(x, y, 1).front)
            }
        }

        # Check the back 
        backColor = findCube(0,0,-1).back
        [-1,0,1].each { |y|
            [-1,0,1].each { |x|
                isSolved = isSolved && (backColor == findCube(x, y, -1).back)
            }
        }

        # Check the down
        downColor = findCube(0,-1,0).down
        [-1,0,1].each { |x|
            [-1,0,1].each { |z|
                isSolved = isSolved && (downColor == findCube(x, -1, z).down)
            }
        }

        isSolved
    end
end
