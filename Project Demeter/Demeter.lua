require "functions.Info_Screen"

local info_screen = Info_Screen.new()

os.setComputerLabel("Demeter")

while true do --warte auf Nachrichten Loop
    --info_screen.Start_Screen()
    local id, message = rednet.receive()
    print("Recieved message from: " .. id)
    if (message) then
        shell.run("message_handler", id, message)
    end
end 
