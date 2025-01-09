Demeter_ID = 7 --ID des Demeter Computers ✓

--Ding ist ich hab glaube ich ein bisschen falsch kalkuliert mit der farming höhe und allem, denke das wäre besser wenn der Turtle gesagt wird geh auf die höhe
-- und mine dann die Rescource, weil aktuell würden die sich von Bedrock langsam Hoch arbeiten.
--Was jetzt quasi hinzugefügt werden muss ist:
--  1. Die Abrsprache mit Demeter was gemined werden soll und auf welcher höhe das liegt, dazu ob da schon gemined wurde
--  ✓  2. Das letzt endliche Stripminen entweder als classisches stripminen was ja mehr in die Breite geht oder mehr längere Tunnel... muss man mal schauen was einfacher oder Effectiver ist ✓
--  3. Der Check wie voll das Inventar ist
--  4. Evtl Refueling mit Lava aber dafür müsste man halt nen slot mit nem Eimer verbrauchen und dann auch noch schauen wo lava ist und smarter weise das speichern oder so

--  5. Hab gerade rausgefunden man kann mehrere Prozesse gleichzeitig laufen lassen, heißt ein zweiter Prozess der auf eine Nachricht von Demeter wartet und dann evtl return to base triggered wäre nice


Start_Time = os.date("%c")


peripheral.find("modem", rednet.open)

Turtle_State = "IDLE" --IDLE, MINING, RETURNING, REFUELING, EMERGENCY
Turtle_Mission = "COAL" --Mission der Turtle, wird benutzt um zu wissen was gemined werden soll | "COAL", "IRON", "COPPER", "GOLD", "REDSTONE", "EMERALD", "LAPIS", "DIAMOND", "THORIUM", "ZINC", "STONE", ""
Target_Depth = -59 --Altes Tiefen system muss überarbeitet werden
Orientation = 0 --Himmelsrichtung der Turtle, 0 ist die start richtung, wird genutzt um rotation zu tracken
Tavel_Distance = 0  --Verbleibende Travel Distance
Start_Max_Travel_Distance = 0 --MAX Travel Distance bevor umgedreht werden muss weil zu wenig fuel da ist
Resource_Name_List = {
    "minecraft:coal_ore", --Liste der Resourcen, wird für den Resourcen checker gebraucht
    "minecraft:deepslate_coal_ore", 
    "minecraft:iron_ore",
    "minecraft:deepslate_iron_ore",
    "minecraft:copper_ore",
    "minecraft:deepslate_copper_ore",
    "minecraft:gold_ore",
    "minecraft:deepslate_gold_ore",
    "minecraft:redstone_ore", 
    "minecraft:deepslate_redstone_ore", 
    "minecraft:emerald_ore",
    "minecraft:deepslate_emerald_ore",
    "minecraft:lapis_ore",
    "minecraft:deepslate_lapis_ore",
    "minecraft:diamond_ore",
    "minecraft:deepslate_diamond_ore",
    "create_new_age:thorium_ore",
    "create:zinc_ore",
    "create:deepslate_zinc_ore",
}
Turtle_movement_nodes = {} --Liste an Nodes die die Turtle schon besucht hat, wird benutzt um den weg zurück zu finden


Title = {
    '+                   ',
    '---------------------------------------',
    '                                       ',
    ' ##### #    # #####  ##### #     ##### ',
    '   #   #    # #    #   #   #     #     ',
    '   #   #    # #    #   #   #     #     ',
    '   #   #    # #####    #   #     ####  ',
    '   #   #    # #    #   #   #     #     ',
    '   #   ##  ## #    #   #   #     #     ',
    '   #    ####  #    #   #   ##### ##### ',
    '                                       ',
    '---------------------------------------',
    ''
}

function PrintTitle() --Gibt den Title aus. ACHTUNG manchmal weirder shit mit hintergrund farben also dannach idealer weise backgroundColor auf black wieder setzten.
    term.clear()
    for y_offset, line in pairs(Title) do
        term.setCursorPos(1, y_offset)
        for char in line:gmatch"." do
            if char == '#' then
                term.setBackgroundColor(colors.white)
            elseif char == '-' then
                term.setBackgroundColor(colors.green)
            elseif char == '+' then
                term.setBackgroundColor(colors.black)
                term.write("DEMETER > Turtle")
            elseif char == '/' then
                term.setBackgroundColor(colors.gray)
            else
                term.setBackgroundColor(colors.black)
            end
            term.write(' ')
        end
    end
    term.setBackgroundColor(colors.black)
    --os.sleep(5)
end

local function write_mission_file(tbl)
    local file = io.open("Turtle_mission.txt", "w")
    if file then
        file:write(textutils.serialize(tbl))
        file:close()
    else
        error("Could not open file for writing")
    end
end

local function read_mission_file()
    local file = io.open("Turtle_mission.txt", "r")
    if file then
        local content = file:read("*a")
        file:close()
        return textutils.unserialize(content)
    else
        error("Could not open file for reading")
    end
end

function IsResource(value) --Hier wird gecheckt ob der als Variable übergebene Wert eine Resource ist
    for i = 1,#Resource_Name_List do
      if (Resource_Name_List[i] == value) then
        return true
      end
    end
    return false
end

function First_Contact_Demeter() --First Contact mit Demeter, wird benutzt um Turtle Mission zu bekommen
    local demeter_message = {Projekt = "Demeter", Command = "REGISTER"}
    rednet.send(Demeter_ID, demeter_message)
    D_id, D_message = rednet.receive()
    if (D_id == Demeter_ID) then
        os.setComputerLabel("Turtle-"..D_message.Mission.."")
        --Irgendwie Mission setzen
    end
end

function Update_Demeter() --Update Demeter mit aktuellen Informationen
    local demeter_message = {Projekt = "Demeter", StartTime = Start_Time, TransmitionTime = os.clock(), Turtle_State = Turtle_State, Mission = Turtle_Mission, Command = "UPDATE", Fuel = Tavel_Distance}
    rednet.send(Demeter_ID, demeter_message)
end

function Request_Mission_Demeter() --Request Demeter für aktuelle Mission
    local demeter_message = {Projekt = "Demeter", Command = "REQUEST"}
    rednet.send(Demeter_ID, demeter_message)
    D_id, D_message = rednet.receive()
    if (D_id == Demeter_ID) then
        --Evaluate Data from Demeter
    end
end

function Calc_Orientation_Depth() --Rechnet die Target Depth aus. Muss überarbeitet werden
    local number = D_message[0]
    local modulo = number % 4

    Target_Depth = Target_Depth + math.floor(number/4)

    for i = 1, modulo, 1 do
        turtle.turnLeft()
    end
end

function EmptyInventoryintoChest() --Leert das gesamte inventar in eine Kiste vor der Turtle
    if (turtle.detect() == true) then
        p1, p2 = turtle.inspect()
        if(p1 == true and p2["name"] == "minecraft:chest") then
            for i = 1, 16, 1 do
                turtle.select(i)
                turtle.drop()
            end
            return true
        end
    else
        return false
    end
end

function StarterRefuel() --!Ist nur beim Starten der Turtle zu verwenden da hier geschaut wir ob eine Chest vorhanden ist. (Theoretisch auch später möglich i guess)
    Turtle_State = "REFUELING"
    local clear_inv = false
    for i = 1, 16, 1 do
        turtle.select(i)
        if turtle.getItemDetail() ~= nil then
            if turtle.getItemDetail()["name"] ~= nil then
                clear_inv = true 
                break
            end
    end
    end

    if clear_inv == true then
        while true do
            if EmptyInventoryintoChest() then
                break
            end
            turtle.turnLeft()
        end
    end


    if (turtle.detectUp() == true) then
    p1, p2 = turtle.inspectUp()
        if(p1 == true and p2["name"] == "minecraft:chest") then
            while true do
                local p1, p2 = turtle.suckUp()
                if not p1 then
                    if p2 == "No space for items" then
                        break
                    elseif p2 == "No items to take" then
                        break --NO ITEMS IN CHEST NOTIFY DEMETER
                    end
                end
            end
        end
        
    end

    for i = 1, 16, 1 do
        turtle.select(i)
        local p1, p2 = turtle.refuel()
        if p2 == nil then
            if (turtle.detectUp() == true) then
                p1, p2 = turtle.inspectUp()
                if(p1 == true and p2["name"] == "minecraft:chest") then
                    for i = 1, 16, 1 do
                        turtle.select(i)
                        turtle.dropUp()
                    end
                end
            end
        end
        
    end
    Calculate_Travel_Distance()
    Start_Max_Travel_Distance = Tavel_Distance
end

function Calculate_Travel_Distance() --!Ist nur beim Starten der Turtle zu verwenden da hier die original Travel_Distance gesetzt wird
    local cur_fuel = turtle.getFuelLevel()
    Tavel_Distance = cur_fuel / 2
end

function Mine_Block(direction) --Direction == "UP" or "DOWN" or "FORWARD"
    local a1, a2
    if direction == "UP" then
        a1, a2 = turtle.digUp()
    elseif direction == "DOWN" then
        a1, a2 = turtle.digDown()
    elseif direction == "FORWARD" then
        a1, a2 = turtle.dig()
    end

    if a1 == false then
        if a2 == "Cannot break unbreakable block" then
            --handle failure
        end
        --other exceptions??
    else
        return true
    end
end

function Movement(direction, steps) --Movemint
    for i = 1, steps, 1 do
        Tavel_Distance = Tavel_Distance - 1 --Schreibe auf das ein Schritt gegangen wurde
        if Tavel_Distance <= (Start_Max_Travel_Distance / 2 -5) then --Checke ob MAX Travel Distance erreicht wurde
            Strip_mine_Contoll = false
            return false
            --start Journey back(TODO)
        end

        Check_for_Resources()

        if Mine_Block(direction) == false then
            --figure out why.... WHYY sollte nicht false sein
        end

        local a1, a2 = true, true
        if direction == "UP" then --bisschen fucky code der die Turtle in eine Richtung bewegt, gibt glaube ich 100 wege das besser zu machen aber der hier ist voll cool
            print("[INFO] Moving UP")
            a1, a2 = turtle.up()
        elseif direction == "DOWN" then
            print("[INFO] Moving Down")
            a1, a2 = turtle.down()
        elseif direction == "FORWARD" then
            print("[INFO] Moving FORWARD")
            a1, a2 = turtle.forward()
        end
        if a1 == false then
            if a2 == "Movement obstructed" then
                --why was it not mined before?
            elseif a2 == "Out of Fuel" then
                --How???
                --send Emergency Help Call to Zeuz / Demeter kp
            end
        end
    end
    return true
end

function Add_movement_node()
    local cur_pos = GetCurPosition()
    table.insert(Turtle_movement_nodes, cur_pos)
end

function Check_for_Resources() --Einen full spin um zu schauen ob Rescourcen in der Nähe sind
    if (turtle.detectUp() == true) then
        p1, p2 = turtle.inspectUp()
        if(IsResource(p2["name"])) then
            Mine_Resource_Node("UP")
        end
    elseif turtle.detectDown() == true then
        p1, p2 = turtle.inspectDown()
        if(IsResource(p2["name"])) then
            Mine_Resource_Node("DOWN")
        end  
    end

    local turn_counter = 0

    for i = 1, 4, 1 do --Spinnnn
        if turtle.detect() == true then
            p1, p2 = turtle.inspect()
            if(IsResource(p2["name"])) then
                Mine_Resource_Node("FORWARD")
            end
        end

        turtle.turnLeft()
        turn_counter = turn_counter + 1
    end

    local mod_turn_counter = turn_counter % 4

    if mod_turn_counter ~= 0 then --unSPINNNNN
        for i = 1, mod_turn_counter, 1 do
            turtle.turnRight()
        end
    end
end

function GetCurPosition() --Gibt akuelle Position an (Funktioniert nur wenn ATLAS auch aktiv ist)<- WICHTIG 
    local l1, l2, l3 = gps.locate()

    local cur_cords = {l1, l2, l3}
    return cur_cords


end

function ReturnBase()
    
end

function Evade_Bedrock() --huh kp wie
    --evade Bedrock
end

Strip_mine_Contoll = true --Stripmine Control Variable wird benutzt um das Stripminen zu stoppen
function Strip_mine_loop()
    Turtle_State = "MINING"
    local inv_check_counter = 0
    while Strip_mine_Contoll do --Muss noch rausfinden wie ich das am einrachsten mache das der Loop sofort abgebrochen wird wenn Strip_mine_Contoll auf false gesetzt wird        
        Movement("FORWARD", 2)
        turtle.turnLeft()
        Movement("FORWARD", 5)
        turtle.turnRight()
        turtle.turnRight()
        Movement("FORWARD", 10)
        turtle.turnLeft()
        turtle.turnLeft()
        Movement("FORWARD", 5)
        turtle.turnRight()

        if inv_check_counter == 10 then
            inv_check_counter = 0
            --Check Inventory
            --Wenn voll dann zurück zur Base und Strip_mine_Contoll auf false setzen
        end
    end
    ReturnBase()
end

function Get_in_start_Position() --Fährt auf die Start(Mining) Position
    Navigate_to_height()
    --in richtige Richtung drehen
end

function Navigate_to_height() --Auf Start Positions Höhe fahren
    while true do
        print(GetCurPosition()[1])
        if GetCurPosition()[1] ~= Target_Depth then
            Movement("DOWN", 1)
        else
            Add_movement_node()
            break
        end
    end

end

function Clear_longterm_Storage() --Löscht die Longterm Storage Datei
    local clear_table = {}
    write_mission_file(clear_table)
end

function Setup()
    os.setComputerLabel("Initiating...")
    First_Contact_Demeter()
    Add_movement_node()
    StarterRefuel()
    Calculate_Travel_Distance()

    Get_in_start_Position()

    Update_Demeter()
end





function Mine_Resource_Node(direction)
    -- Startposition speichern
    local startPos = GetCurPosition()
    local startOrientation = Orientation

    print("[INFO] Checking for Resource Node")
    
    -- Resource Map erstellen mit relativen Koordinaten
    local resourceMap = {
        checked = {},
        toCheck = {{x=0, y=0, z=0}} -- Relative Position zum Startpunkt
    }
    
    -- Wenn die Ressource vor uns ist, einen Schritt nach vorne
    if direction == "FORWARD" then
        mineForward()
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
                mineForward()
                currentPos = GetCurPosition()
            end
            while currentPos[1] > startPos[1] + currentBlock.x do
                while Orientation ~= 3 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
                mineForward()
                currentPos = GetCurPosition()
            end
            
            -- Z-Position
            while currentPos[3] < startPos[3] + currentBlock.z do
                while Orientation ~= 2 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
                mineForward()
                currentPos = GetCurPosition()
            end
            while currentPos[3] > startPos[3] + currentBlock.z do
                while Orientation ~= 0 do turtle.turnRight() Orientation = (Orientation + 1) % 4 end
                mineForward()
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

function mineForward() 
    Tavel_Distance = Tavel_Distance - 1 --Schreibe auf das ein Schritt gegangen wurde
    if Tavel_Distance <= (Start_Max_Travel_Distance / 2 -5) then --Checke ob MAX Travel Distance erreicht wurde
        Strip_mine_Contoll = false
        return false
        --start Journey back(TODO)
    end

    turtle.dig()
    turtle.forward()
end

PrintTitle()
Setup()
Navigate_to_height()
Strip_mine_loop() --Starte Stripmine Prozess











--Calc_Orientation_Depth()







--Clear_longterm_Storage()
--aktuell ist es einfacher wenn die Turtle fertig ist mit einem Mining durchgang sie neu zu starten und ihr dann wieder ein Ziel zu geben


