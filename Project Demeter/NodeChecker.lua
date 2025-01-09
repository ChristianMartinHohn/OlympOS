require "Logger"

NodeChecker = {}
NodeChecker.new = function()
    local self = {}

    local logger = Logger.new()

    local resourceNodeCoordinates = {}

    local function check()
        -- Check if a resource node is infornt of the turtle
        local success, data = turtle.inspect()
        if success then
            if self.resourceValid(data.name) then
                logger.log("info", "Found resource node: " .. data.name)
                local x, y, z = gps.locate()

                    -- Save the resource node position
                    -- Change the coords based on the orientation
                    if Orientation == 0 then
                        z = z - 1
                    elseif Orientation == 2 then
                        x = x + 1
                    elseif Orientation == 3 then
                        z = z + 1
                    elseif Orientation == 4 then
                        x = x - 1
                    end

                table.insert(resourceNodeCoordinates, vector.new(x, y, z))
            end
        end

        local success, data = turtle.inspectUp()
        if success then
            if self.resourceValid(data.name) then
                logger.log("info", "Found resource node: " .. data.name)

                local x, y, z = gps.locate()
                table.insert(resourceNodeCoordinates, vector.new(x, y + 1, z))
            end
        end

        local success, data = turtle.inspectDown()
        if success then
            if self.resourceValid(data.name) then
                logger.log("info", "Found resource node: " .. data.name)

                local x, y, z = gps.locate()
                table.insert(resourceNodeCoordinates, vector.new(x, y - 1, z))
            end
        end

        -- If resourceNodeCoordinates not empty
        if #resourceNodeCoordinates > 0 then
            self.mineResourceNodes()
        end
    end

    function self.mineResourceNodes()
        -- Save the current position
        local x, y, z = gps.locate()
        StartPos = vector.new(x, y, z)
        StartOrtion = Orientation
        logger.log("info", "Saved current position: " .. x .. ", " .. y .. ", " .. z)
        logger.log("info", "Saved current orientation: " .. Orientation)

        self.moveToCoords(resourceNodeCoordinates[1].x, resourceNodeCoordinates[1].y, resourceNodeCoordinates[1].z)
        self.checkSurroundings()
        
        -- Iterate the resource node coordinates until empty
        for i = 1, #resourceNodeCoordinates do
            local coords = resourceNodeCoordinates[i]
            local x, y, z = coords.x, coords.y, coords.z
            self.moveToCoords(x, y, z)
            self.checkSurroundings()

            -- Remove the current coords from table
            table.remove(resourceNodeCoordinates, i)
        end

        -- Move back to the starting position
        self.moveToCoords(StartPos.x, StartPos.y, StartPos.z)
        self.turnTo(StartOrtion)
    end

    -- Check the surroundings of the turtle
    function self.checkSurroundings()
        for i = 0, 3 do
            local success, data = turtle.inspect()
            if success then
                if self.resourceValid(data.name) then
                    local x, y, z = gps.locate()

                    -- Save the resource node position
                    -- Change the coords based on the orientation
                    if Orientation == 0 then
                        z = z - 1
                    elseif Orientation == 2 then
                        x = x + 1
                    elseif Orientation == 3 then
                        z = z + 1
                    elseif Orientation == 4 then
                        x = x - 1
                    end

                    table.insert(resourceNodeCoordinates, vector.new(x, y, z))
                end
            end
            turtle.turnRight()
            Orientation = (Orientation + 1) % 4
        end

        -- Check the top and bottom of the turtle
        local success, data = turtle.inspectUp()
        if success then
            if self.resourceValid(data.name) then
                local x, y, z = gps.locate()
                table.insert(resourceNodeCoordinates, vector.new(x, y + 1, z))
            end
        end

        local success, data = turtle.inspectDown()
        if success then
            if self.resourceValid(data.name) then
                local x, y, z = gps.locate()
                table.insert(resourceNodeCoordinates, vector.new(x, y - 1, z))
            end
        end
    end


    -- This function is used to move the turtle to the saved coordinates
    function self.moveToCoords(x, y, z)
        local currentX, currentY, currentZ = gps.locate()
        local xDiff = x - currentX
        local yDiff = y - currentY
        local zDiff = z - currentZ

        -- Move along the x-axis
        if xDiff > 0 then
            self.turnTo(2) -- East
            for i = 1, xDiff do
                turtle.dig()
                self.forward()
            end
        elseif xDiff < 0 then
            self.turnTo(4) -- West
            for i = 1, -xDiff do
                turtle.dig()
                self.forward()
            end
        end

        -- Move along the z-axis
        if zDiff > 0 then
            self.turnTo(3) -- South
            for i = 1, zDiff do
                turtle.dig()
                self.forward()
            end
        elseif zDiff < 0 then
            self.turnTo(0) -- North
            for i = 1, -zDiff do
                turtle.dig()
                self.forward()
            end
        end

        -- Move along the y-axis
        if yDiff > 0 then
            for i = 1, yDiff do
                turtle.digUp()
                turtle.up()
            end
        elseif yDiff < 0 then
            for i = 1, -yDiff do
                turtle.digDown()
                turtle.down()
            end
        end
    end

    function self.turnTo(direction)
        while Orientation ~= direction do
            turtle.turnRight()
            Orientation = (Orientation + 1) % 4
        end
    end

    function self.forward()
        turtle.dig()
        turtle.forward()
    end

    function self.resourceValid(string)
        for _, resource in ipairs(ResourceNameList) do
            if string.find(resource, string) then
                return resource
            end
            
        end
        return false
    end

    self.check = check

    return self
end