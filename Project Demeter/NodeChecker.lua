NodeChecker = {}
NodeChecker.new = function()
    local self = {}

    local logger = Logger.new()

    local resourceNodeCoordinates = {}
    local isMining = false

    local function sortCoordinates()
        local currentX, currentY, currentZ = gps.locate()
        logger.log("debug", "Sorting coordinates based on current position: (" .. currentX .. ", " .. currentY .. ", " .. currentZ .. ")")
        for _, coord in ipairs(resourceNodeCoordinates) do
            logger.log("debug", "Before sort: (" .. coord.x .. ", " .. coord.y .. ", " .. coord.z .. ")")
        end
        table.sort(resourceNodeCoordinates, function(a, b)
            local distA = math.abs(a.x - currentX) + math.abs(a.y - currentY) + math.abs(a.z - currentZ)
            local distB = math.abs(b.x - currentX) + math.abs(b.y - currentY) + math.abs(b.z - currentZ)
            return distA < distB
        end)
        for _, coord in ipairs(resourceNodeCoordinates) do
            logger.log("debug", "After sort: (" .. coord.x .. ", " .. coord.y .. ", " .. coord.z .. ")")
        end
    end

    local function check()
        -- Check if a resource node is in front of the turtle
        local success, data = turtle.inspect()
        if success then
            if self.resourceValid(data.name) then
                logger.log("info", "Found resource node in front: " .. data.name)
                local x, y, z = gps.locate()

                -- Save the resource node position
                -- Change the coords based on the orientation
                if Orientation == 0 then
                    z = z - 1
                elseif Orientation == 1 then
                    x = x + 1
                elseif Orientation == 2 then
                    z = z + 1
                elseif Orientation == 3 then
                    x = x - 1
                end

                -- Check if the coordinates are already in the list
                local alreadyExists = false
                for _, coord in ipairs(resourceNodeCoordinates) do
                    if coord.x == x and coord.y == y and coord.z == z then
                        alreadyExists = true
                        break
                    end
                end

                if not alreadyExists then
                    table.insert(resourceNodeCoordinates, vector.new(x, y, z))
                    logger.log("debug", "Coordinates before sorting: " .. textutils.serialize(resourceNodeCoordinates))
                    sortCoordinates()
                    logger.log("debug", "Coordinates after sorting: " .. textutils.serialize(resourceNodeCoordinates))
                    logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. y .. ", " .. z .. ")")
                end
            end
        end

        success, data = turtle.inspectUp()
        if success then
            if self.resourceValid(data.name) then
                logger.log("info", "Found resource node above: " .. data.name)

                local x, y, z = gps.locate()

                -- Check if the coordinates are already in the list
                local alreadyExists = false
                for _, coord in ipairs(resourceNodeCoordinates) do
                    if coord.x == x and coord.y == y + 1 and coord.z == z then
                        alreadyExists = true
                        break
                    end
                end

                if not alreadyExists then
                    table.insert(resourceNodeCoordinates, vector.new(x, y + 1, z))
                    logger.log("debug", "Coordinates before sorting: " .. textutils.serialize(resourceNodeCoordinates))
                    sortCoordinates()
                    logger.log("debug", "Coordinates after sorting: " .. textutils.serialize(resourceNodeCoordinates))
                    logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. (y + 1) .. ", " .. z .. ")")
                end
            end
        end

        success, data = turtle.inspectDown()
        if success then
            if self.resourceValid(data.name) then
                logger.log("info", "Found resource node below: " .. data.name)

                local x, y, z = gps.locate()

                -- Check if the coordinates are already in the list
                local alreadyExists = false
                for _, coord in ipairs(resourceNodeCoordinates) do
                    if coord.x == x and coord.y == y - 1 and coord.z == z then
                        alreadyExists = true
                        break
                    end
                end

                if not alreadyExists then
                    table.insert(resourceNodeCoordinates, vector.new(x, y - 1, z))
                    logger.log("debug", "Coordinates before sorting: " .. textutils.serialize(resourceNodeCoordinates))
                    sortCoordinates()
                    logger.log("debug", "Coordinates after sorting: " .. textutils.serialize(resourceNodeCoordinates))
                    logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. (y - 1) .. ", " .. z .. ")")
                end
            end
        end

        -- If resourceNodeCoordinates not empty
        if #resourceNodeCoordinates > 0 and not isMining then
            os.setComputerLabel("Harvesting resource node")
            isMining = true
            self.mineResourceNodes()
            isMining = false
        end

        
        -- Reset global variables
        resourceNodeCoordinates = {}
        StartPos = nil
        StartOrtion = nil
        os.setComputerLabel("Stripmining for " .. MineForResource)
    end

    function self.mineResourceNodes()
        -- Save the current position
        local x, y, z = gps.locate()
        StartPos = vector.new(x, y, z)
        StartOrtion = Orientation
        logger.log("info", "Saved current position: (" .. x .. ", " .. y .. ", " .. z .. ")")
        logger.log("info", "Saved current orientation: " .. Orientation)

        while #resourceNodeCoordinates > 0 do
            local coords = table.remove(resourceNodeCoordinates, 1)
            local x, y, z = coords.x, coords.y, coords.z
            self.moveToCoords(x, y, z)
            self.checkSurroundings()
        end

        -- Move back to the starting position
        logger.log("info", "Done mining Resource Node! Moving back to starting position")
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
                    elseif Orientation == 1 then
                        x = x + 1
                    elseif Orientation == 2 then
                        z = z + 1
                    elseif Orientation == 3 then
                        x = x - 1
                    end

                    -- Check if the coordinates are already in the list
                    local alreadyExists = false
                    for _, coord in ipairs(resourceNodeCoordinates) do
                        if coord.x == x and coord.y == y and coord.z == z then
                            alreadyExists = true
                            break
                        end
                    end

                    if not alreadyExists then
                        table.insert(resourceNodeCoordinates, vector.new(x, y, z))
                        logger.log("debug", "Coordinates before sorting: " .. textutils.serialize(resourceNodeCoordinates))
                        sortCoordinates()
                        logger.log("debug", "Coordinates after sorting: " .. textutils.serialize(resourceNodeCoordinates))
                        logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. y .. ", " .. z .. ")")
                    end
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

                -- Check if the coordinates are already in the list
                local alreadyExists = false
                for _, coord in ipairs(resourceNodeCoordinates) do
                    if coord.x == x and coord.y == y + 1 and coord.z == z then
                        alreadyExists = true
                        break
                    end
                end

                if not alreadyExists then
                    table.insert(resourceNodeCoordinates, vector.new(x, y + 1, z))
                    logger.log("debug", "Coordinates before sorting: " .. textutils.serialize(resourceNodeCoordinates))
                    sortCoordinates()
                    logger.log("debug", "Coordinates after sorting: " .. textutils.serialize(resourceNodeCoordinates))
                    logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. (y + 1) .. ", " .. z .. ")")
                end
            end
        end

        success, data = turtle.inspectDown()
        if success then
            if self.resourceValid(data.name) then
                local x, y, z = gps.locate()

                -- Check if the coordinates are already in the list
                local alreadyExists = false
                for _, coord in ipairs(resourceNodeCoordinates) do
                    if coord.x == x and coord.y == y - 1 and coord.z == z then
                        alreadyExists = true
                        break
                    end
                end

                if not alreadyExists then
                    table.insert(resourceNodeCoordinates, vector.new(x, y - 1, z))
                    logger.log("debug", "Coordinates before sorting: " .. textutils.serialize(resourceNodeCoordinates))
                    sortCoordinates()
                    logger.log("debug", "Coordinates after sorting: " .. textutils.serialize(resourceNodeCoordinates))
                    logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. (y - 1) .. ", " .. z .. ")")
                end
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
            self.turnTo(1) -- East
            for i = 1, xDiff do
                turtle.dig()
                self.forward()
            end
        elseif xDiff < 0 then
            self.turnTo(3) -- West
            for i = 1, -xDiff do
                turtle.dig()
                self.forward()
            end
        end

        -- Move along the z-axis
        if zDiff > 0 then
            self.turnTo(2) -- South
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