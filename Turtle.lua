Start_Time = os.date("%c")

Demeter_ID = 17
peripheral.find("modem", rednet.open)
Base_Cords = {}

Depth = 0
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

function TableContains(table, value)
    for i = 1,#table do
      if (table[i] == value) then
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
    
    if modulo == 0 then
        local division_num = number / 4
        local multiplication_num = division_num *2
        Depth = -59 - multiplication_num
    end
    
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

function Movement(Direction)
    Tavel_Distance = Tavel_Distance -1
    if Tavel_Distance <= (Start_Max_Travel_Distance / 2 -5) then
        --start Journey back
    end

    if Direction == "UP" then
        local a1, a2 = turtle.up()
    elseif Direction == "DOWN" then
        local a1, a2 = turtle.down()
    elseif Direction == "FORWARD" then
        local a1, a2 = turtle.forward()
    end
end

function Check_for_Recources()
    if (turtle.detectUp() == true) then
        p1, p2 = turtle.inspectUp()
        if(p2["name"]) then
            print("yur")
        end
    end
end

function GetStartPosition()
    local l1, l2, l3 = gps.locate()
    Base_Cords[0] = l1
    Base_Cords[1] = l2
    Base_Cords[2] = l3
end

function Evade_Bedrock()
    --evade Bedrock
end

function Navigate_to_height()
    
end

PrintTitle()
--Contact_Demeter()
--Calc_Orientation_Depth()
--StarterRefuel()
--Calculate_Travel_Distance()
--GetStartPosition()

print(TableContains(Recource_Name_List, "minecraft:lapis_ore"))