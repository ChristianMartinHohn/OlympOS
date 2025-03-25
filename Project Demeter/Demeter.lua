require "functions.Info_Screen"
require "functions.Communication"

local info_screen = Info_Screen.new()
local communication = Communication.new()


os.setComputerLabel("Demeter")


while true do --warte auf Nachrichten Loop
    local id, message = rednet.receive()
    if (message) then
        local decrypted_message = communication.decrypt_turtle_message(message, id)
        if string.find(decrypted_message, "@") then
            print("The message contains the '@' character.")
        else
            print("The message does not contain the '@' character.")
        end
        print(decrypted_message)
    end
end 
