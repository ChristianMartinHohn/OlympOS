require "functions.Logger"

NodeChecker = {}
NodeChecker.new = function()
    local self = {}

    local logger = Logger.new()
    --local demeter = Comms.new()

    -- Holds the coordinates of newly discovered resource nodes.
    local resourceNodeCoordinates = {}

    -- Flag to indicate whether the turtle is currently mining.
    local isMining = false

    ----------------------------------------------------------------------------
    -- Sorts the coordinate list based on the turtle's current position.
    -- This ensures we always go to the nearest node first.
    ----------------------------------------------------------------------------
    local function sortCoordinates()
        local currentX, currentY, currentZ = self.getCurPosition()
        table.sort(resourceNodeCoordinates, function(a, b)
            local distA = math.abs(a.x - currentX) + math.abs(a.y - currentY) + math.abs(a.z - currentZ)
            local distB = math.abs(b.x - currentX) + math.abs(b.y - currentY) + math.abs(b.z - currentZ)
            return distA < distB
        end)
    end

    ----------------------------------------------------------------------------
    -- Checks for resource blocks in front, above, and below.
    -- If it finds any, it adds their coordinates to the resourceNodeCoordinates.
    ----------------------------------------------------------------------------
    local function check()
        -- Check in front
        local success, data = turtle.inspect()
        if success and self.resourceValid(data.name) then
            logger.log("info", "Found resource node in front: " .. data.name)
            local x, y, z = self.getCurPosition()

            -- Adjust the coordinate based on current Orientation
            if Orientation == 0 then
                z = z - 1
            elseif Orientation == 1 then
                x = x + 1
            elseif Orientation == 2 then
                z = z + 1
            elseif Orientation == 3 then
                x = x - 1
            end

            -- Insert if not already in the list
            local alreadyExists = false
            for _, coord in ipairs(resourceNodeCoordinates) do
                if coord.x == x and coord.y == y and coord.z == z then
                    alreadyExists = true
                    break
                end
            end
            if not alreadyExists then
                table.insert(resourceNodeCoordinates, vector.new(x, y, z))
                sortCoordinates()
                logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. y .. ", " .. z .. ")")
            end
        end

        -- Check above
        success, data = turtle.inspectUp()
        if success and self.resourceValid(data.name) then
            logger.log("info", "Found resource node above: " .. data.name)
            local x, y, z = self.getCurPosition()

            local alreadyExists = false
            for _, coord in ipairs(resourceNodeCoordinates) do
                if coord.x == x and coord.y == y + 1 and coord.z == z then
                    alreadyExists = true
                    break
                end
            end
            if not alreadyExists then
                table.insert(resourceNodeCoordinates, vector.new(x, y + 1, z))
                sortCoordinates()
                logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. (y + 1) .. ", " .. z .. ")")
            end
        end

        -- Check below
        success, data = turtle.inspectDown()
        if success and self.resourceValid(data.name) then
            logger.log("info", "Found resource node below: " .. data.name)
            local x, y, z = self.getCurPosition()

            local alreadyExists = false
            for _, coord in ipairs(resourceNodeCoordinates) do
                if coord.x == x and coord.y == y - 1 and coord.z == z then
                    alreadyExists = true
                    break
                end
            end
            if not alreadyExists then
                table.insert(resourceNodeCoordinates, vector.new(x, y - 1, z))
                sortCoordinates()
                logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. (y - 1) .. ", " .. z .. ")")
            end
        end

        -- If we have resource coordinates and we're not currently mining, start mining
        if #resourceNodeCoordinates > 0 and not isMining then
            os.setComputerLabel("Harvesting resource node")
            isMining = true
            self.mineResourceNodes()
            isMining = false
        end

        -- Reset only these globals; do not clear resourceNodeCoordinates here.
        StartPos = nil
        StartOrtion = nil
        os.setComputerLabel("Stripmining for " .. MineForResource)
    end

    ----------------------------------------------------------------------------
    -- Mines the resource nodes by traveling to each saved coordinate,
    -- checking surroundings, and then returning to the start.
    ----------------------------------------------------------------------------
    function self.mineResourceNodes()
        -- Remember current position and orientation
        local x, y, z = self.getCurPosition()
        StartPos = vector.new(x, y, z)
        StartOrtion = Orientation
        logger.log("info", "Saved current position: (" .. x .. ", " .. y .. ", " .. z .. ")")
        logger.log("info", "Saved current orientation: " .. Orientation)

        -- Keep mining until we've exhausted the coordinate list
        while #resourceNodeCoordinates > 0 do
            local coords = table.remove(resourceNodeCoordinates, 1)
            local tx, ty, tz = coords.x, coords.y, coords.z
            self.moveToCoords(tx, ty, tz)
            self.checkSurroundings()
        end

        -- Once done, return to the starting position and orientation
        self.moveToCoords(StartPos.x, StartPos.y, StartPos.z)
        self.turnTo(StartOrtion)
    end

    ----------------------------------------------------------------------------
    -- Checks the surroundings in all four directions plus top and bottom,
    -- adding any newly found resource nodes to the coordinate list.
    ----------------------------------------------------------------------------
    function self.checkSurroundings()
        -- Check in all four directions (front) by turning around once
        for _ = 0, 3 do
            local success, data = turtle.inspect()
            if success and self.resourceValid(data.name) then
                local x, y, z = self.getCurPosition()

                if Orientation == 0 then
                    z = z - 1
                elseif Orientation == 1 then
                    x = x + 1
                elseif Orientation == 2 then
                    z = z + 1
                elseif Orientation == 3 then
                    x = x - 1
                end

                local alreadyExists = false
                for _, coord in ipairs(resourceNodeCoordinates) do
                    if coord.x == x and coord.y == y and coord.z == z then
                        alreadyExists = true
                        break
                    end
                end
                if not alreadyExists then
                    table.insert(resourceNodeCoordinates, vector.new(x, y, z))
                    sortCoordinates()
                    logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. y .. ", " .. z .. ")")
                end
            end
            self.turnRight()
        end

        -- Check above
        local upSuccess, upData = turtle.inspectUp()
        if upSuccess and self.resourceValid(upData.name) then
            local x, y, z = self.getCurPosition()

            local alreadyExists = false
            for _, coord in ipairs(resourceNodeCoordinates) do
                if coord.x == x and coord.y == y + 1 and coord.z == z then
                    alreadyExists = true
                    break
                end
            end
            if not alreadyExists then
                table.insert(resourceNodeCoordinates, vector.new(x, y + 1, z))
                sortCoordinates()
                logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. (y + 1) .. ", " .. z .. ")")
            end
        end

        -- Check below
        local downSuccess, downData = turtle.inspectDown()
        if downSuccess and self.resourceValid(downData.name) then
            local x, y, z = self.getCurPosition()

            local alreadyExists = false
            for _, coord in ipairs(resourceNodeCoordinates) do
                if coord.x == x and coord.y == y - 1 and coord.z == z then
                    alreadyExists = true
                    break
                end
            end
            if not alreadyExists then
                table.insert(resourceNodeCoordinates, vector.new(x, y - 1, z))
                sortCoordinates()
                logger.log("info", "Added new resource node coordinates: (" .. x .. ", " .. (y - 1) .. ", " .. z .. ")")
            end
        end
    end

    ----------------------------------------------------------------------------
    -- Moves the turtle from its current position to the target (x, y, z),
    -- digging in front to clear obstructions, and adjusting orientation as needed.
    ----------------------------------------------------------------------------
    function self.moveToCoords(x, y, z)
        local curX, curY, curZ = self.getCurPosition()
        local xDiff = x - curX
        local yDiff = y - curY
        local zDiff = z - curZ

        -- Move along the x-axis
        if xDiff > 0 then
            self.turnTo(1) -- East
            for _ = 1, xDiff do
                turtle.dig()
                self.forward()
            end
        elseif xDiff < 0 then
            self.turnTo(3) -- West
            for _ = 1, -xDiff do
                turtle.dig()
                self.forward()
            end
        end

        -- Move along the z-axis
        if zDiff > 0 then
            self.turnTo(2) -- South
            for _ = 1, zDiff do
                turtle.dig()
                self.forward()
            end
        elseif zDiff < 0 then
            self.turnTo(0) -- North
            for _ = 1, -zDiff do
                turtle.dig()
                self.forward()
            end
        end

        -- Move along the y-axis (up/down)
        if yDiff > 0 then
            for _ = 1, yDiff do
                turtle.digUp()
                turtle.up()
            end
        elseif yDiff < 0 then
            for _ = 1, -yDiff do
                turtle.digDown()
                turtle.down()
            end
        end
    end

    ----------------------------------------------------------------------------
    -- Orients the turtle to face the given direction [0=N, 1=E, 2=S, 3=W]
    -- with minimal turning (could use left or right).
    ----------------------------------------------------------------------------
    function self.turnTo(targetDir)
        local diff = (targetDir - Orientation) % 4
        if diff == 0 then
            -- already facing the correct direction
        elseif diff == 1 then
            -- turn right once
            self.turnRight()
        elseif diff == 2 then
            -- 180 degrees
            self.turnRight()
            self.turnRight()
        elseif diff == 3 then
            -- turn left once
            self.turnLeft()
        end
    end

    function self.turnRight()
        turtle.turnRight()
        Orientation = (Orientation + 1) % 4
    end

    function self.turnLeft()
        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        if Orientation < 0 then
            Orientation = Orientation + 4
        end
    end

    ----------------------------------------------------------------------------
    -- Moves the turtle forward, attempting to dig if obstructed by gravel/sand.
    ----------------------------------------------------------------------------
    function self.forward()
        turtle.dig()
        local success, reason = turtle.forward()
        if not success then
            logger.log("error", "Cannot move forward: " .. (reason or "Unknown reason"))
            -- If it's obstructed by gravel or sand, dig until it succeeds
            while reason == "Movement obstructed" do
                local blocked, data = turtle.inspect()
                if blocked and (data.name == "minecraft:gravel" or data.name == "minecraft:sand") then
                    turtle.dig()
                    success, reason = turtle.forward()
                    if success then
                        break
                    end
                else
                    -- Some other obstruction
                    break
                end
            end
        end
    end

    ----------------------------------------------------------------------------
    -- Returns true if blockName is exactly in the ResourceNameList.
    ----------------------------------------------------------------------------
    function self.resourceValid(blockName)
        for _, resource in ipairs(ResourceNameList) do
            if resource == blockName then
                return resource
            end
        end
        return false
    end

    ----------------------------------------------------------------------------
    -- Attempts to find GPS location. If it fails after 3 tries, abort the program.
    ----------------------------------------------------------------------------
    function self.getCurPosition()
        local x, y, z = gps.locate()
        if not x or not y or not z then
            logger.log("error", "GPS not found. Cannot get current position.")
            for i = 1, 3 do
                logger.log("error", "Trying GPS location again: attempt " .. i .. "/3")
                x, y, z = gps.locate()
                if x and y and z then
                    logger.log("info", "GPS location found.")
                    break
                end
            end
            if not x or not y or not z then
                Turtle_State = "EMERGENCY"
                logger.log("error", "GPS location still not found. Aborting the program.")
                --demeter.Send_Update("GPS location not found. Aborting the program.")
                error("GPS location not found. Aborting the program.")
            end
        end
        return x, y, z
    end

    ----------------------------------------------------------------------------
    -- Expose the main 'check' function outside.
    ----------------------------------------------------------------------------
    self.check = check

    return self
end
