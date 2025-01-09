require "NodeChecker"
require "Logger"

Move = {}
Move.new = function ()
    local self = {}
    
    local logger = Logger.new()
    local nodeChecker = NodeChecker.new()

    local function down()
        turtle.digDown()
        
        a1, a2 = turtle.down()
        if a1 == false then
            logger.log("error", a2)
            return false
        end

        Travel_Distance = Travel_Distance - 1
    end

    local function up()
        turtle.digUp()
        
        a1, a2 = turtle.up()
        if a1 == false then
            logger.log("error", a2)
            return false
        end
        
        Travel_Distance = Travel_Distance - 1
    end
    
    local function forward()
        turtle.dig()
        self.move()
    end

    local function back()
        turtle.turnLeft()
        nodeChecker.check()

        turtle.turnLeft()
        nodeChecker.check()

        turtle.dig()
        self.move()

        turtle.turnLeft()
        nodeChecker.check()
        
        turtle.turnLeft()
        nodeChecker.check()
    end

    local function left()
        turtle.turnLeft()
        nodeChecker.check()

        turtle.dig()
        self.move()

        turtle.turnRight()
        nodeChecker.check()
    end

    local function right()
        turtle.turnRight()
        nodeChecker.check()

        turtle.dig()
        turtle.forward()

        turtle.turnLeft()
        nodeChecker.check()
    end

    function move()
        a1, a2 = turtle.forward()
        if a1 == false then
            logger.log("error", a2)
            return false
        end
        
        Travel_Distance = Travel_Distance - 1
        nodeChecker.check()
    end

    -- Public Methods
    self.down = down
    self.up = up
    self.forward = forward
    self.back = back
    self.left = left
    self.right = right

    -- Private Methods
    self.move = move

    return self
end