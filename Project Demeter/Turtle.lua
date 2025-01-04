--Ding ist ich hab glaube ich ein bisschen falsch kalkuliert mit der farming höhe und allem, denke das wäre besser wenn der Turtle gesagt wird geh auf die höhe
-- und mine dann die Rescource, weil aktuell würden die sich von Bedrock langsam Hoch arbeiten.
--Was jetzt quasi hinzugefügt werden muss ist:
--  1. Die Abrsprache mit Demeter was gemined werden soll und auf welcher höhe das liegt, dazu ob da schon gemined wurde
--  2. Das letzt endliche Stripminen entweder als classisches stripminen was ja mehr in die Breite geht oder mehr längere Tunnel... muss man mal schauen was einfacher oder Effectiver ist
--  3. Der Check wie voll das Inventar ist
--  4. Evtl Refueling mit Lava aber dafür müsste man halt nen slot mit nem Eimer verbrauchen und dann auch noch schauen wo lava ist und smarter weise das speichern oder so




Start_Time = os.date("%c")

Demeter_ID = 17
peripheral.find("modem", rednet.open)
Base_Cords = {}

Target_Depth = -59 --Altes Tiefen system muss überarbeitet werden
Orientation = 0 --Himmelsrichtung der Turtle, 0 ist die start richtung, wird genutzt um rotation zu tracken
Tavel_Distance = 0  --Verbleibende Travel Distance
Start_Max_Travel_Distance = 0 --MAX Travel Distance bevor umgedreht werden muss weil zu wenig fuel da ist
Resource_Name_List = {"minecraft:coal_ore", --Liste der Resourcen, wird für den Resourcen checker gebraucht
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

function IsResource(value) --Hier wird gecheckt ob der als Variable übergebene Wert eine Resource ist
    for i = 1,#Resource_Name_List do
      if (Resource_Name_List[i] == value) then
        return true
      end
    end
    return false
  end

function Contact_Demeter() --Start Kontakt mit Demeter muss auch überarbeitet werden
    local demeter_message = {Projekt = "Demeter", StartTime = Start_Time, TransmitionTime = os.clock()}
    rednet.send(Demeter_ID, demeter_message)
    print("waiting for msg")
    D_id, D_message = rednet.receive()
    if (D_id == Demeter_ID) then
        os.setComputerLabel("Slave D-"..D_message[0].."")
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

function Mine_Block(Direction) --Direction == "UP" or "DOWN" or "FORWARD"
    local a1, a2
    if Direction == "UP" then
        a1, a2 = turtle.digUp()
    elseif Direction == "DOWN" then
        a1, a2 = turtle.digDown()
    elseif Direction == "FORWARD" then
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

function Movement(Direction)

    Tavel_Distance = Tavel_Distance - 1 --Schreibe auf das ein Schritt gegangen wurde
    if Tavel_Distance <= (Start_Max_Travel_Distance / 2 -5) then --Checke ob MAX Travel Distance erreicht wurde
        --start Journey back(TODO)
    end

    Check_for_Resources()

    if Mine_Block(Direction) == false then
        --figure out why.... WHYY sollte nicht false sein
    end

    local a1, a2 = true, true
    if Direction == "UP" then --bisschen fucky code der die Turtle in eine Richtung bewegt, gibt glaube ich 100 wege das besser zu machen aber der hier ist voll cool
        a1, a2 = turtle.up()
    elseif Direction == "DOWN" then
        a1, a2 = turtle.down()
    elseif Direction == "FORWARD" then
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
    return true
end

function Mine_Resource_Node(direction) --absolut kp wie das gemacht wird
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
                Mine_Resource_Node("FRONT")
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



function Evade_Bedrock() --huh kp wie
    --evade Bedrock
end

function Navigate_to_height() --Auf Start Positions Höhe fahren
    while true do
        if GetCurPosition()[1] ~= Target_Depth then
            Movement("DOWN")
        else
            break
        end
    end

end

--PrintTitle()
--Contact_Demeter()
--Calc_Orientation_Depth()
StarterRefuel()
--Calculate_Travel_Distance()
--Base_Cords = GetStartPosition()

--Navigate_to_height()


