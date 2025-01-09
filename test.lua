function Mine_Resource_Node(direction)
    -- Startposition speichern
    local startPos = GetCurPosition()
    local startOrientation = Orientation
    
    -- Resource Map erstellen mit relativen Koordinaten
    local resourceMap = {
        checked = {},
        toCheck = {{x=0, y=0, z=0}} -- Relative Position zum Startpunkt
    }
    
    -- Wenn die Ressource vor uns ist, einen Schritt nach vorne
    if direction == "FORWARD" then
        Movement(direction, 1)
    end
    
    -- Ressourcen-Cluster abbauen
    while #resourceMap.toCheck > 0 do
        local currentBlock = table.remove(resourceMap.toCheck)
        local key = currentBlock.x..","..currentBlock.y..","..currentBlock.z
        
        if not resourceMap.checked[key] then
            resourceMap.checked[key] = true
            
            -- Zur Position navigieren
            local currentPos = GetCurPosition()
            
            -- Y-Position
            while currentPos[2] < startPos[2] + currentBlock.y do Movement("UP", 1) currentPos = GetCurPosition() end
            while currentPos[2] > startPos[2] + currentBlock.y do Movement("DOWN", 1) currentPos = GetCurPosition() end
            
            -- X-Position
            while currentPos[1] < startPos[1] + currentBlock.x do
                while Orientation ~= 1 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
                Movement("FORWARD", 1)
                currentPos = GetCurPosition()
            end
            while currentPos[1] > startPos[1] + currentBlock.x do
                while Orientation ~= 3 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
                Movement("FORWARD", 1)
                currentPos = GetCurPosition()
            end
            
            -- Z-Position
            while currentPos[3] < startPos[3] + currentBlock.z do
                while Orientation ~= 2 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
                Movement("FORWARD", 1)
                currentPos = GetCurPosition()
            end
            while currentPos[3] > startPos[3] + currentBlock.z do
                while Orientation ~= 0 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
                Movement("FORWARD", 1)
                currentPos = GetCurPosition()
            end
            
            -- Block scannen und abbauen
            local success, data = inspectCurrentBlock(direction)
            if success and IsResource(data.name) then
                Mine_Block(direction)
                
                -- Nachbarblöcke zur Prüfung hinzufügen
                addNeighborsToCheck(currentBlock, resourceMap)
            end
        end
    end
    
    -- Zurück zur Startposition
    local currentPos = GetCurPosition()
    if currentPos[1] ~= startPos[1] or currentPos[2] ~= startPos[2] or currentPos[3] ~= startPos[3] then
        -- Y-Position
        while currentPos[2] < startPos[2] do Movement("UP", 1) currentPos = GetCurPosition() end
        while currentPos[2] > startPos[2] do Movement("DOWN", 1) currentPos = GetCurPosition() end
        
        -- X-Position
        while currentPos[1] < startPos[1] do
            while Orientation ~= 1 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
            Movement("FORWARD", 1)
            currentPos = GetCurPosition()
        end
        while currentPos[1] > startPos[1] do
            while Orientation ~= 3 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
            Movement("FORWARD", 1)
            currentPos = GetCurPosition()
        end
        
        -- Z-Position
        while currentPos[3] < startPos[3] do
            while Orientation ~= 2 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
            Movement("FORWARD", 1)
            currentPos = GetCurPosition()
        end
        while currentPos[3] > startPos[3] do
            while Orientation ~= 0 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
            Movement("FORWARD", 1)
            currentPos = GetCurPosition()
        end
    end
    
    -- Ursprüngliche Orientierung wiederherstellen
    while Orientation ~= startOrientation do
        turtle.turnRight()
        Orientation = (Orientation + 1) % 4
    end
end

-- Hilfsfunktionen
function navigateToRelativePos(pos)
    -- Y-Bewegung
    while pos.y > 0 do turtle.up() pos.y = pos.y - 1 end
    while pos.y < 0 do turtle.down() pos.y = pos.y + 1 end
    
    -- X-Bewegung
    while pos.x > 0 do
        while Orientation ~= 1 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
        turtle.forward()
        pos.x = pos.x - 1
    end
    while pos.x < 0 do
        while Orientation ~= 3 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
        turtle.forward()
        pos.x = pos.x + 1
    end
    
    -- Z-Bewegung
    while pos.z > 0 do
        while Orientation ~= 2 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
        turtle.forward()
        pos.z = pos.z - 1
    end
    while pos.z < 0 do
        while Orientation ~= 0 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
        turtle.forward()
        pos.z = pos.z + 1
    end
end

function inspectCurrentBlock(direction)
    if direction == "UP" then return turtle.inspectUp()
    elseif direction == "DOWN" then return turtle.inspectDown()
    else return turtle.inspect() end
end

function addNeighborsToCheck(pos, resourceMap)
    local neighbors = {
        {x=pos.x+1, y=pos.y, z=pos.z},
        {x=pos.x-1, y=pos.y, z=pos.z},
        {x=pos.x, y=pos.y+1, z=pos.z},
        {x=pos.x, y=pos.y-1, z=pos.z},
        {x=pos.x, y=pos.y, z=pos.z+1},
        {x=pos.x, y=pos.y, z=pos.z-1}
    }
    
    for _, neighbor in ipairs(neighbors) do
        local key = neighbor.x..","..neighbor.y..","..neighbor.z
        if not resourceMap.checked[key] then
            table.insert(resourceMap.toCheck, neighbor)
        end
    end
end

function returnToStartPos(startPos)
    local x, y, z = gps.locate()
    if x then
        -- Zurück zur Startposition navigieren
        while y < startPos.y do turtle.up() y = y + 1 end
        while y > startPos.y do turtle.down() y = y - 1 end
        
        while x < startPos.x do
            while Orientation ~= 1 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
            turtle.forward()
            x = x + 1
        end
        while x > startPos.x do
            while Orientation ~= 3 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
            turtle.forward()
            x = x - 1
        end
        
        while z < startPos.z do
            while Orientation ~= 2 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
            turtle.forward()
            z = z + 1
        end
        while z > startPos.z do
            while Orientation ~= 0 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
            turtle.forward()
            z = z - 1
        end
        
        -- Ursprüngliche Orientierung wiederherstellen
        while Orientation ~= startPos.orientation do
            turtle.turnRight()
            Orientation = (Orientation + 1) % 4
        end
    end
end