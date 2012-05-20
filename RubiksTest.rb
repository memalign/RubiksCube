#!/usr/bin/ruby
#

require 'RubiksCube'
require 'RubiksSimpleSolver'

# A couple of patterns from here: http://www.math.ucf.edu/~reid/Rubik/patterns.html
def performCheckers(cube)
    cube.performTransform("F")
    cube.performTransform("F")
    cube.performTransform("B")
    cube.performTransform("B")
    cube.performTransform("R")
    cube.performTransform("R")
    cube.performTransform("L")
    cube.performTransform("L")
    cube.performTransform("U")
    cube.performTransform("U")
    cube.performTransform("D")
    cube.performTransform("D")
end

def performStripes(cube)
    transform = "F,U,F,R,L,L,B,D',R,D,D,L,D',B,R,R,L,F,U,F"
    transform.split(',').each { |trans|
        cube.performTransform(trans)
    }
end

def performCubeInCube(cube)
    transform = "F,L,F,U',R,U,F,F,L,L,U',L',B,D',B',L,L,U"
    transform.split(',').each { |trans|
        cube.performTransform(trans)
    }
end

def randomMix
    transform = ""

    moves = ["F", "B", "L", "R", "U", "D", "x", "y", "z"]
    numMoves = rand(20)+1 # Between 1 and 20 moves

    comma = ""
    (1..numMoves).each { |i|
        move = moves[rand(moves.length)]
        prime = (rand(2) == 0) ? "" : "'"
        transform << "#{comma}#{move}#{prime}"
        comma = ","
    }

    transform
end

cube = RubiksCube.new
#performCheckers(cube)
#performStripes(cube)
#performCubeInCube(cube)
#cube.performTransform("z")
#
puts "Initial cube:\n#{cube.to_s}"
#transform = "R',U',D,y,R,U"
#transform.split(',').each { |t|
#    cube.performTransform(t)
#}
transform = randomMix
puts "Using random mix #{transform}"
transform.split(",").each { |t|
    cube.performTransform(t)
}

puts "After mix:\n#{cube.to_s}"
solver = RubiksSimpleSolver.new(cube)
solver.solve
puts "Is solved? #{cube.isSolved}"
puts "Cube:\n#{cube.to_s}"
