Start_Time = os.date("%c")

Demeter_ID = 17
peripheral.find("modem", rednet.open)
Base_Cords = {}

Target_Depth = -59
Orientation = 0
Tavel_Distance = 0
Start_Max_Travel_Distance = 0
Recource_Name_List = {"minecraft:coal_ore",
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

function PrintTitle()
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

function IsRescource(value)
    for i = 1,#Recource_Name_List do
      if (Recource_Name_List[i] == value) then
        return true
      end
    end
    return false
  end

function Contact_Demeter()
    local demeter_message = {Projekt = "Demeter", StartTime = Start_Time, TransmitionTime = os.clock()}
    rednet.send(Demeter_ID, demeter_message)
    print("waiting for msg")
    D_id, D_message = rednet.receive()
    if (D_id == Demeter_ID) then
        os.setComputerLabel("Slave D-"..D_message[0].."")
    end
end

function Calc_Orientation_Depth()
    local number = D_message[0]
    local modulo = number % 4

    Target_Depth = Target_Depth + math.floor(number/4)

    for i = 1, modulo, 1 do
        turtle.turnLeft()
    end

end

function EmptyInventoryintoChest()
    if (turtle.detect() == true) then
        p1, p2 = turtle.inspect()
        if(p1 == true and p2["name"] == "minecraft:chest") then
            for i = 1, 16, 1 do
                turtle.select(i)
                turtle.drop()
            end
            return true
        end
    end
end

function StarterRefuel()
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

function Calculate_Travel_Distance()
    local cur_fuel = turtle.getFuelLevel()
    Tavel_Distance = cur_fuel / 2
end

function Mine_Block(Direction)
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

    Tavel_Distance = Tavel_Distance - 1
    if Tavel_Distance <= (Start_Max_Travel_Distance / 2 -5) then
        --start Journey back
    end

    Check_for_Recources()

    if Mine_Block(Direction) == false then
        --figure out why
    end

    local a1, a2 = true, true
    if Direction == "UP" then
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
            --send Emergency Help Call to Zeuz
        end
    end
    return true
end

function Mine_Recource_Node(direction)
end

function Check_for_Recources()
    if (turtle.detectUp() == true) then
        p1, p2 = turtle.inspectUp()
        if(IsRescource(p2["name"])) then
            Mine_Recource_Node("UP")
        end
    elseif turtle.detectDown() == true then
        p1, p2 = turtle.inspectDown()
        if(IsRescource(p2["name"])) then
            Mine_Recource_Node("DOWN")
        end  
    end

    local turn_counter = 0

    for i = 1, 4, 1 do
        if turtle.detect() == true then
            p1, p2 = turtle.inspect()
            if(IsRescource(p2["name"])) then
                Mine_Recource_Node("FRONT")
            end
        end

        turtle.turnLeft()
        turn_counter = turn_counter + 1
    end

    local mod_turn_counter = turn_counter % 4

    if mod_turn_counter ~= 0 then
        for i = 1, mod_turn_counter, 1 do
            turtle.turnRight()
        end
    end
end

function GetStartPosition()
    local l1, l2, l3 = gps.locate()

    local cur_cords = {l1, l2, l3}
    return cur_cords


end



function Evade_Bedrock()
    --evade Bedrock
end

function Navigate_to_height()
    while true do
        if GetStartPosition()[1] ~= Target_Depth then
            Movement("DOWN")
        else
            break
        end
    end

end

--PrintTitle()
--Contact_Demeter()
--Calc_Orientation_Depth()
--StarterRefuel()
--Calculate_Travel_Distance()
--Base_Cords = GetStartPosition()

--Navigate_to_height()


