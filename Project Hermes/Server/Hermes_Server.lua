os.setComputerLabel("Hermes")

local start_screen = {
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
}

--local shell_id = shell.openTab("Info_Screen")

--shell.switchTab(shell_id)

local function animation()
    for i = 1, 51, 1 do
        for y_offset, line in pairs(start_screen) do
            term.setCursorPos(1, y_offset)
            for char in line:gmatch"." do
                if char == '1' then
                    term.setBackgroundColor(colors.black)
                    for j=1 , i, 1 do
                        term.write(" ")
                    end
                    term.setBackgroundColor(colors.white)
                    term.write("              ")
                elseif char == "2" then
                    term.setBackgroundColor(colors.black)
                    for j=1 , i, 1 do
                        term.write(" ")
                    end
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write(" ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("        ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write(" ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                elseif char == "3" then
                    term.setBackgroundColor(colors.black)
                    for j=1 , i, 1 do
                        term.write(" ")
                    end
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write(" ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("        ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write(" ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                elseif char == "4" then
                    term.setBackgroundColor(colors.black)
                    for j=1 , i, 1 do
                        term.write(" ")
                    end
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("  ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("      ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("  ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                elseif char == "5" then
                    term.setBackgroundColor(colors.black)
                    for j=1 , i, 1 do
                        term.write(" ")
                    end
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("   ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("    ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("   ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                elseif char == "6" then
                    term.setBackgroundColor(colors.black)
                    for j=1 , i, 1 do
                        term.write(" ")
                    end
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("    ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("  ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("    ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                elseif char == "7" then
                    term.setBackgroundColor(colors.black)
                    for j=1 , i, 1 do
                        term.write(" ")
                    end
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("     ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                    term.setBackgroundColor(colors.black)
                    term.write("     ")
                    term.setBackgroundColor(colors.white)
                    term.write(" ")
                elseif char == "8" then
                    term.setBackgroundColor(colors.black)
                    for j=1 , i, 1 do
                        term.write(" ")
                    end
                    term.setBackgroundColor(colors.white)
                    term.write("              ")
                end
            end
            
        end
        term.setBackgroundColor(colors.black)
        sleep(1)
    end
end

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
