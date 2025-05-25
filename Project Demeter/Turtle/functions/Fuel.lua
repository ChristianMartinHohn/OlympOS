--evtl hier einfügen wenn die Turtle kein fuel mehr hat einen emergency call an Demeter senden

Fuellist = {
    "minecraft:coal", 
    "minecraft:charcoal", 
    "minecraft:coal_block", 
    "minecraft:charcoal_block"
    --können hier noch überlegen ob wir noch lava Eimer hinzufügen aber kann sein das damit die Turtle nicht klar kommt weil der Eimer liegen bleibt
    --oder wir machen das die Turtle den Eimer in den Lava Eimer Block craftet und dann den Block abbaut und in den Lava Eimer Block setzt
}

Screen = {
    '+                   ',
    '---------------------------------------',
    ' -9999999- %',
    ' -8888888-                             ',
    ' -7777777-                             ',
    ' -6666666-                             ',
    ' -5555555- !',
    ' -4444444-                             ',
    ' -3333333-                             ',
    ' -2222222-                             ',
    ' -1111111- §',
    '---------------------------------------',
    ''
}

Fuel = {}
Fuel.new = function ()
    local self = {}

    local function refuel_on_mission()
        -- Refuelt die Turtle mit den vorhandenen Resourcen, kann genutzt werden um die Turtle Travel_Distance zu erhöhen
        if UseResourcestoRefuel == true then
            Turtle_State = "REFUELING"
            for i = 1, 16 do
                turtle.select(i)
                for _, item in ipairs(fuellist) do
                    if turtle.getItemDetail() and turtle.getItemDetail().name == item then
                        turtle.refuel()
                    end
                end
            end
            turtle.select(1)
        end
    
        local current_travel_distance = Travel_Distance
    
    end

    local function getFuelPercent()
        local fuelLevel = turtle.getFuelLevel()
        local fuelLimit = turtle.getFuelLimit()
        local fuelPercent = (fuelLevel / fuelLimit) * 100
        return math.floor(fuelPercent)
    end

    local function show_FuelScreen()
        local fuelPercent = getFuelPercent()
        term.clear()
        for y_offset, line in pairs(Screen) do
            term.setCursorPos(1, y_offset)
            for char in line:gmatch"." do
                if char == '9' then
                    if fuelPercent > 90 then
                        term.setBackgroundColor(colors.green)
                    else
                        term.setBackgroundColor(colors.gray)
                    end
                elseif char == '8' then
                    if fuelPercent > 80 then
                        term.setBackgroundColor(colors.green)
                    else
                        term.setBackgroundColor(colors.gray)
                    end
                elseif char == '7' then
                    if fuelPercent > 70 then
                        term.setBackgroundColor(colors.green)
                    else
                        term.setBackgroundColor(colors.gray)
                    end
                elseif char == '6' then
                    if fuelPercent > 60 then
                        term.setBackgroundColor(colors.green)
                    else
                        term.setBackgroundColor(colors.gray)
                    end
                elseif char == '5' then
                    if fuelPercent > 50 then
                        term.setBackgroundColor(colors.green)
                    else
                        term.setBackgroundColor(colors.gray)
                    end
                elseif char == '4' then
                    if fuelPercent > 40 then
                        term.setBackgroundColor(colors.yellow)
                    else
                        term.setBackgroundColor(colors.gray)
                    end
                elseif char == '3' then
                    if fuelPercent > 30 then
                        term.setBackgroundColor(colors.yellow)
                    else
                        term.setBackgroundColor(colors.gray)
                    end
                elseif char == '2' then
                    if fuelPercent > 20 then
                        term.setBackgroundColor(colors.red)
                    else
                        term.setBackgroundColor(colors.gray)
                    end
                elseif char == '1' then
                    if fuelPercent > 10 then
                        term.setBackgroundColor(colors.red)
                    else
                        term.setBackgroundColor(colors.gray)
                    end
                
                elseif char == '+' then
                    term.write("Turtle: ")
                    term.write(os.getComputerID())
                    term.write(" - Fuel Gauge")
                elseif char == '%' then
                    term.write(fuelPercent)
                    term.write("% ")
                    term.write("Fuel")
                elseif char == '!' then
                    if fuelPercent < 15 then
                        term.setBackgroundColor(colors.red)
                        term.write("REFUEL NOW!")
                        term.setBackgroundColor(colors.black)
                    elseif fuelPercent < 50 then
                        term.setBackgroundColor(colors.yellow)
                        term.write("Low Fuel")
                        term.setBackgroundColor(colors.black)
                    else
                        term.setBackgroundColor(colors.green)
                        term.write("Fuel OK")
                        term.setBackgroundColor(colors.black)
                    end
                elseif char == '§' then
                    term.write("Travel_Distance: ")
                    term.write(Travel_Distance)
                elseif char == '-' then
                    term.setBackgroundColor(colors.brown)
                else
                    term.setBackgroundColor(colors.black)
                end
                term.write(' ')
                term.setBackgroundColor(colors.black)
            end
        end
        term.setBackgroundColor(colors.black)
    end

    local function first_refuel()
        show_FuelScreen()
        while true do
            for i = 1, 16 do
                turtle.select(i)
                for _, item in ipairs(Fuellist) do
                    if turtle.getItemDetail() and turtle.getItemDetail().name == item then
                        turtle.refuel()
                    end
                end
            end
            turtle.select(1)
            Travel_Distance = turtle.getFuelLevel() / 2
            show_FuelScreen()
            sleep(5)
            if getFuelPercent() > 30 then
                break
            end
        end
        
end

    -- Public Methods
    self.refuel_on_mission = refuel_on_mission
    self.first_refuel = first_refuel
    self.getFuelPercent = getFuelPercent
    self.show_FuelScreen = show_FuelScreen

    return self
end
