
module RubiksColor
    YELLOW = "y" 
    BLUE = "b" 
    RED = "r"
    WHITE = "w"
    ORANGE = "o"
    GREEN = "g"
    HIDDEN = "h"
end

class RubiksPoint
    attr_reader :x, :y, :z
    def initialize(x, y, z)
        @x = x
        @y = y
        @z = z
    end

    def rotate(axis, cw)
        xmult = (axis != :x && !cw) ? -1 : 1
        ymult = (axis != :y && !cw) ? -1 : 1
        zmult = (axis != :z && !cw) ? -1 : 1
        newX = RubiksMatrix.get(axis)[:x].x * xmult * @x + RubiksMatrix.get(axis)[:x].y * ymult * @y + RubiksMatrix.get(axis)[:x].z * zmult * @z
        newY = RubiksMatrix.get(axis)[:y].x * xmult * @x + RubiksMatrix.get(axis)[:y].y * ymult * @y + RubiksMatrix.get(axis)[:y].z * zmult * @z
        newZ = RubiksMatrix.get(axis)[:z].x * xmult * @x + RubiksMatrix.get(axis)[:z].y * ymult * @y + RubiksMatrix.get(axis)[:z].z * zmult * @z
        #puts "Rotating #{@x} #{@y} #{@z} to #{newX} #{newY} #{newZ}"
        @x = newX
        @y = newY
        @z = newZ
    end
end

class RubiksMatrix
    def initialize(x1, y1, z1,
                   x2, y2, z2,
                   x3, y3, z3)
        @points = {} 
        @points[:x] = RubiksPoint.new(x1,y1,z1)
        @points[:y] = RubiksPoint.new(x2,y2,z2)
        @points[:z] = RubiksPoint.new(x3,y3,z3)
    end

    @@TRANSFORMS = {}
    @@TRANSFORMS[:z] = RubiksMatrix.new(0, 1, 0,
                                        -1, 0, 0,
                                        0, 0, 1)
    @@TRANSFORMS[:y] = RubiksMatrix.new(0, 0, -1,
                                        0, 1, 0,
                                        1, 0, 0)
    @@TRANSFORMS[:x] = RubiksMatrix.new(1, 0, 0,
                                        0, 0, 1,
                                        0, -1, 0)

    def [](p)
        @points[p]
    end

    def RubiksMatrix.get(axis)
        @@TRANSFORMS[axis]
    end
end

module CubeSides
    UP = 1
    FRONT = 2
    RIGHT = 3
    LEFT = 4
    BACK = 5
    DOWN = 6
end

class RubiksColorSwap

    attr_reader :a, :b
    def initialize(a, b)
        @a = a
        @b = b
    end

    @@TRANSFORMS = {}
    @@TRANSFORMS[:x] = [RubiksColorSwap.new(1,5),
                        RubiksColorSwap.new(2,1),
                        RubiksColorSwap.new(3,3),
                        RubiksColorSwap.new(4,4),
                        RubiksColorSwap.new(5,6),
                        RubiksColorSwap.new(6,2)]

    @@TRANSFORMS[:y] = [RubiksColorSwap.new(1,1),
                        RubiksColorSwap.new(2,4),
                        RubiksColorSwap.new(3,2),
                        RubiksColorSwap.new(4,5),
                        RubiksColorSwap.new(5,3),
                        RubiksColorSwap.new(6,6)]

    @@TRANSFORMS[:z] = [RubiksColorSwap.new(1,3), #UP rotates to be in the RIGHT position; new value for b is a
                        RubiksColorSwap.new(2,2),
                        RubiksColorSwap.new(3,6),
                        RubiksColorSwap.new(4,1),
                        RubiksColorSwap.new(5,5),
                        RubiksColorSwap.new(6,4)]


    # Return the new value for side
    def RubiksColorSwap.rotatedValue(side, sides, axis, cw)
        @@TRANSFORMS[axis].each { |rcs|
            if (cw && (rcs.b == side))
                # new value for b is the value at a
                return sides[rcs.a]
            elsif (!cw && (rcs.a == side))
                return sides[rcs.b]
            end
        }

        puts "Uh oh, didn't find a new value in RCS rotatedValue"
        return -1
    end
end

class RubiksSubcube
   # A subcube is one of the 9+8+9 pieces that makes up a rubiks cube
    #
    
    # A subcube has an up, front, back, left, right, down 
    def initialize(x, y, z, up, front, back, left, right, down)
        @coord = RubiksPoint.new(x,y,z)
        @sides = []
        @sides[CubeSides::UP] = up
        @sides[CubeSides::FRONT] = front
        @sides[CubeSides::RIGHT] = right
        @sides[CubeSides::LEFT] = left
        @sides[CubeSides::BACK] = back
        @sides[CubeSides::DOWN] = down
    end

    def up
        @sides[CubeSides::UP]
    end

    def front
        @sides[CubeSides::FRONT]
    end

    def right
        @sides[CubeSides::RIGHT]
    end

    def left
        @sides[CubeSides::LEFT]
    end

    def back
        @sides[CubeSides::BACK]
    end

    def down
        @sides[CubeSides::DOWN]
    end

    def x
        @coord.x
    end

    def y
        @coord.y
    end

    def z
        @coord.z
    end

    def hasCoordinates(x, y, z)
        return (@coord.x == x) && (@coord.y == y) && (@coord.z == z)
    end

    def isCenterOfFace
        vals = [@coord.x, @coord.y, @coord.z]
        numZero = 0
        vals.each { |val|
            if (val == 0)
                numZero += 1
            end
        }
        return numZero == 2
    end

    def isCorner
        vals = [@coord.x, @coord.y, @coord.z]
        numOne = 0
        vals.each { |val|
            if (val == 1 || val == -1)
                numOne += 1
            end
        }
        return numOne == 3
    end

    def isEdge
        return (!isCorner && !isCenterOfFace && !hasCoordinates(0,0,0))
    end

    def hasColor(color)
        @sides.each { |side|
           if (side == color)
               return true
           end
        }
        return false
    end

    def rotate(axis, cw)
        # transform coordinates
        #puts "Rotating #{@coord}"
        @coord.rotate(axis, cw)

        # transform colors
        up = RubiksColorSwap.rotatedValue(CubeSides::UP, @sides, axis, cw)
        front = RubiksColorSwap.rotatedValue(CubeSides::FRONT, @sides, axis, cw)
        right = RubiksColorSwap.rotatedValue(CubeSides::RIGHT, @sides, axis, cw)
        left = RubiksColorSwap.rotatedValue(CubeSides::LEFT, @sides, axis, cw)
        back = RubiksColorSwap.rotatedValue(CubeSides::BACK, @sides, axis, cw)
        down = RubiksColorSwap.rotatedValue(CubeSides::DOWN, @sides, axis, cw)
        @sides[CubeSides::UP] = up
        @sides[CubeSides::FRONT] = front
        @sides[CubeSides::RIGHT] = right
        @sides[CubeSides::LEFT] = left
        @sides[CubeSides::BACK] = back
        @sides[CubeSides::DOWN] = down
    end

    def to_s
        ret = "\n"
        ret << "        B=#{@sides[CubeSides::BACK]}\n"
        ret << "       ____\n"
        ret << "      / #{@sides[CubeSides::UP]} /|\n"
        ret << "L=#{@sides[CubeSides::LEFT]}  /___/#{@sides[CubeSides::RIGHT]}|  (#{@coord.x},#{@coord.y},#{@coord.z})\n"
        ret << "     | #{@sides[CubeSides::FRONT]} | /\n"
        ret << "     |___|/ \n"
        ret << "\n"
        ret << "       D=#{@sides[CubeSides::DOWN]}\n"
        ret
    end
end
