Zeus_ID = 7
Start_Time = os.date("%c")

Title = {
    '                                                   ',
    '---------------------------------------------------',
    '                                                   ',
    '         #  #######  #          #      ######      ',
    '        ###    #     #         ###    ##           ',
    '       #   #   #     #        #   #   ##           ',
    '      #     #  #     #       #     #   #####       ',
    '      #######  #     #       #######       ##      ',
    '      #     #  #     #       #     #       ##      ',
    '      #     #  #     ######  #     #  ######       ',
    '                                                   ',
    '---------------------------------------------------',
    '              +           ',
    '---------------------------------------------------',
    '                                                   ',
    '                                                   ',
    '                                                   '
}

os.setComputerLabel("Atlas")

Cord_X = 0
Cord_Y = 0
Cord_Z = 0

Cords_Set = false


function PrintTitle()
    term.setBackgroundColor(colors.black)
    term.clear()
    for y_offset, line in pairs(Title) do
        term.setCursorPos(1, y_offset)
        for char in line:gmatch"." do
            if char == '#' then
                term.setBackgroundColor(colors.white)
            elseif char == '-' then
                term.setBackgroundColor(colors.brown)
            elseif char == '+' then
                term.write("The World on my Shoulders")
            elseif char == '/' and Cords_Set == false then
                term.setBackgroundColor(colors.gray)
            else
                term.setBackgroundColor(colors.black)
            end
            term.write(' ')
        end
    end
    term.setBackgroundColor(colors.black)
    if Cords_Set == true then
        local cord_len = string.len(Cord_X)
        cord_len = cord_len + string.len(Cord_Y)
        cord_len = cord_len + string.len(Cord_Z)
        cord_len = cord_len + 10
        local field_lenght = (28 - (cord_len/2))
        term.setCursorPos(field_lenght, 1)
        term.write("<X:"..Cord_X.." Y:"..Cord_Y.." Z:"..Cord_Z..">")
        term.setCursorPos(25, 18)
    end
end

function Contact_Zeus()
    peripheral.find("modem", rednet.open)
    local zeus_message = {Projekt = "Atlas", StartTime = Start_Time, TransmitionTime = os.clock(), Position = {Cord_X, Cord_Y, Cord_Z}}
    rednet.send(Zeus_ID, zeus_message)
end

local function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
  end

function Read_Cord_Save()
    if not file_exists("Cord_Save.txt") then 
        local f = io.open("Cord_Save.txt", "w")
        if f ~= nil then
            f:write("0\n0\n0")
            f:close()
        end
    end

    local lines = {}
    for line in io.lines("Cord_Save.txt") do
        lines[#lines + 1] = line
    end
    return lines
end

function Write_Cord_Save(X, Y, Z)
    local f = io.open("Cord_Save.txt", "w")
        if f ~= nil then
            f:write(""..X.."\n"..Y.."\n"..Z.."")
            f:close()
        end
end

function Ask_Cords()
    PrintTitle()
    term.setCursorPos(15, 17)
    term.write("Please Enter X Cordinate:")
    term.setCursorPos(24, 18)
    Cord_X = read()
    PrintTitle()
    term.setCursorPos(15, 17)
    term.write("Please Enter Y Cordinate:")
    term.setCursorPos(24, 18)
    Cord_Y = read()
    PrintTitle()
    term.setCursorPos(15, 17)
    term.write("Please Enter Z Cordinate:")
    term.setCursorPos(24, 18)
    Cord_Z = read()
    Cords_Set = true
    Write_Cord_Save(Cord_X, Cord_Y, Cord_Z)
end

function Boot()
    local past_Cords = Read_Cord_Save()
    if past_Cords[1] == "0" and past_Cords[2] == "0" and past_Cords[3] == "0" then
        Ask_Cords()
    else
        Cord_X = past_Cords[1]
        Cord_Y = past_Cords[2]
        Cord_Z = past_Cords[3]
        Cords_Set = true
    end

    
    PrintTitle()
    term.setCursorPos(1, 16)
    peripheral.find("modem", rednet.open)
    Contact_Zeus()
    shell.run("gps", "host", Cord_X, Cord_Y, Cord_Z)
end

p1, p2 = peripheral.find("modem")

if p1 == nil then
    local txt = "A Modem is missing"
    local field_lenght = (28 - (string.len(txt)/2))
    Cords_Set = true
    PrintTitle()
    term.setCursorPos(field_lenght, 17)
    term.write(txt)
    term.setCursorPos(field_lenght +1, 1)
else
    Boot()
end


