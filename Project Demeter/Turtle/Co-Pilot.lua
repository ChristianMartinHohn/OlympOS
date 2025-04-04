require "functions.Communication"
require "functions.Progress"

local communication = Communication.new()

Offline_Mode = false


Modem_attached = communication.setup_locate_modem()
if Modem_attached == false then
    Offline_Mode = true
    return false
else
    Offline_Mode = false
    DemeterID = communication.setup_Demeter_Connection()
end

if Offline_Mode == true or DemeterID == nil then
    print("Offline Mode. Cannot update Demeter")
else
    while true do
        --hier werden auf anweisungen von Demeter gewartet, die frage ist jetzt nur wie diese in den main prozess eingebaut werden
        --im schlimmsten fall turtle neustarten und vorher status richtig setzten
        local id, message = rednet.receive(nil, 600) -- Wait for a message for 10 minutes (600 seconds)
        if not id then
            print("No message received")
        else
            if id == DemeterID then
                if string.find(message, "@") then
                    print("sus")
                else
                    print("Unknown message type")
                end
            else
                print(("Message from unknown ID %d: %s"):format(id, message))
            end
            print(("Computer %d sent message %s"):format(id, message))
        end
    
        communication.send_update(message)
    end
end

