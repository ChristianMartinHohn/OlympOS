os.setComputerLabel("Demeter")

peripheral.find("modem", rednet.open)

local shell_id = shell.openTab("Info_Screen")

shell.switchTab(shell_id)

if not rednet.host("Demeter", "Demeter") then
    print("Demeter already running, exiting...")
    exit()
end

while true do --warte auf Nachrichten Loop
    local id, message, protocol = rednet.receive()
    print("Recieved message from: " .. id)
    if (message) then
        shell.openTab("message_handler", id, message, protocol)
    end
end