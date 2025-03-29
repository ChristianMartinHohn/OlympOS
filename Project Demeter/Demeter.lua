os.setComputerLabel("Demeter")

local shell_id = shell.openTab("Info_Screen")

shell.switchTab(shell_id)

while true do --warte auf Nachrichten Loop
    --info_screen.Start_Screen()
    local id, message = rednet.receive()
    print("Recieved message from: " .. id)
    if (message) then
        shell.openTab("message_handler", id, message)
    end
end
