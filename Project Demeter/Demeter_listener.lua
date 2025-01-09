peripheral.find("modem", rednet.open)

local function read_mission_file()
    local file = io.open("Turtle_mission.txt", "r")
    if file then
        local content = file:read("*a")
        file:close()
        return textutils.unserialize(content)
    else
        return false
    end
end

--warte auf Nachrichten Loop
while true do
    local id, message = rednet.receive()
    if (message) then
        if (message.Projekt == "Demeter") then
            if message.Command == "RETURN" then
                --Return to Base
            elseif message.Command == "INVENTORY" then
                --Return Inventory
            elseif message.Command == "FUEL" then
                local mission = read_mission_file()
                local fuel = mission["Fuel_Percent"]
                if fuel ~= nil then
                    rednet.send(id, {Projekt = "Demeter", Command = "AWNSER", Fuel = fuel})
                end
            elseif message.Command == "COORDINATES" then
                local mission = read_mission_file()
                local cords = mission["Current_Position"]
                if cords ~= nil then
                    rednet.send(id, {Projekt = "Demeter", Command = "AWNSER", Coordinates = cords})
                end
            elseif message.Command == "STATE" then
                local mission = read_mission_file()
                local state = mission["Turtle_State"]
                if state ~= nil then
                    rednet.send(id, {Projekt = "Demeter", Command = "AWNSER", State = state})
                end
            end
        end
    end
end 

