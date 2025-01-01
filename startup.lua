Mountain = {
    '                                  #                ',
    '                                 ###               ',
    '                                #####              ',
    '                               #######             ',
    '                               ########            ',
    '           #                  #########            ',
    '          ###                ############          ',
    '         #####              ##############         ',
    '         ######           #################        ',
    '       #########         ####################      ',
    '      ###########      #######          #####      ',
    '      ############   ######### @######    ',
    '    ##########################          ########   ',
    '   ##############################################  ',
    '   ##############################################  ',
    '  #################################################',
    '###################################################',
    '###################################################',
    '                                                   ',
    '---------------------------------------------------',
    '                                                   ',
    '      #####   #   #     #  ##       ##  #####      ',
    '     #     #  #    #   #   # #     # #  #    #     ',
    '     #     #  #     # #    # #     # #  #    #     ',
    '     #     #  #      #     #  #   #  #  #####      ',
    '     #     #  #      #     #  #   #  #  #          ',
    '     #     #  #      #     #   # #   #  #          ',
    '      #####   #####  #     #    #    #  # *        ',
    '                                                   ',
    '---------------------------------------------------',
    '                  +                                ',
    '---------------------------------------------------',
    '                                                   ',
    '                                                   ',
    '                                                   ',
    '                                                   ',
}

Mountain2 = {
    '                                  #                ',
    '                                 ###               ',
    '                                #####              ',
    '                               #######             ',
    '                               ########            ',
    '           #                  #########            ',
    '          ###                ############          ',
    '         #####              ##############         ',
    '         ######           #################        ',
    '       #########         ####################      ',
    '      ###########      #######          #####      ',
    '      ############   ######### @######    ',
    '    ##########################          ########   ',
    '   ##############################################  ',
    '   ##############################################  ',
    '  #################################################',
    '###################################################',
    '###################################################',}

Mountain3 = {
    '                                 # #               ',
    '                                #   #              ',
    '                               #     #             ',
    '                              #       #            ',
    '                              #        #           ',
    '          # #                #         #           ',
    '         #   #              #            #         ',
    '        #     #            #              #        ',
    '        #      #         #                 #       ',
    '      #         #       #                    #     ',
    '     #           #    #                      #     ',
    '     #            #  #         @      #    ',
    '    #                                           #  ',
    '  #                                              # ',
    '  #                                              # ',
    ' #                                                #',
    '#                                                 #',
    '#                                                 #',}

Top_line ={
'###################################################'}

Project_to_Load = false

function LoadMountain(sleep_time)
    term.clear()
    for y_offset, line in pairs(Mountain) do
        term.setCursorPos(1, 19)
        for char in line:gmatch"." do
            if char == '#' then
                term.setBackgroundColor(colors.white)
            elseif char == '-' then
                term.setBackgroundColor(colors.orange)
            elseif char == '+' then
                term.write("Home of the Gods")
            elseif char == '/' and Cords_Set == false then
                term.setBackgroundColor(colors.gray)
            elseif char == '*' then
                term.write(".OS")
            elseif char == '@' then
                term.write("©Chriszs")
            else
                term.setBackgroundColor(colors.black)
            end
            term.write(' ')
        end
        term.scroll(1)
        os.sleep(sleep_time)
    end
    os.sleep(sleep_time + sleep_time)
end

function ClosingMountain(sleep_time)
    term.clear()
    for y_offset, line in pairs(Mountain2) do
        term.setCursorPos(1, 19)
        for char in line:gmatch"." do
            if char == '#' then
                term.setBackgroundColor(colors.white)
            elseif char == '-' then
                term.setBackgroundColor(colors.orange)
            elseif char == '+' then
                term.write("Home of the Gods")
            elseif char == '/' and Cords_Set == false then
                term.setBackgroundColor(colors.gray)
            elseif char == '*' then
                term.write(".OS")
            elseif char == '@' then
                term.write("©Chriszs")
            else
                term.setBackgroundColor(colors.black)
            end
            term.write(' ')
        end
        term.scroll(1)
    end
    os.sleep(0.5)
    term.clear()
    for y_offset, line in pairs(Mountain3) do
        term.setCursorPos(1, 19)
        for char in line:gmatch"." do
            if char == '#' then
                term.setBackgroundColor(colors.white)
            elseif char == '-' then
                term.setBackgroundColor(colors.orange)
            elseif char == '+' then
                term.write("Home of the Gods")
            elseif char == '/' and Cords_Set == false then
                term.setBackgroundColor(colors.gray)
            elseif char == '*' then
                term.write(".OS")
            elseif char == '@' then
                term.write("©Chriszs")
            else
                term.setBackgroundColor(colors.black)
            end
            term.write(' ')
        end
        term.scroll(1)
    end
    term.setCursorPos(1, 1)
    os.sleep(2)
end

local function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

function Read_Boot_save()
    if not file_exists("Boot.txt") then 
        local f = io.open("Boot.txt", "w")
        if f ~= nil then
            f:write("0")
            f:close()
        end
    end

    local lines = {}
    for line in io.lines("Boot.txt") do
        lines[#lines + 1] = line
    end
    return lines
end

function Write_Boot_save(god)
    local f = io.open("Boot.txt", "w")
        if f ~= nil then
            f:write(god)
            f:close()
        end
end

function FindGods()
    local god_list = {}
    if file_exists("Zeus.lua") then 
        god_list[#god_list+1] = "Zeus"
    end
    if file_exists("Atlas.lua") then 
        god_list[#god_list+1] = "Atlas"
    end
    if file_exists("Demeter.lua") then 
        god_list[#god_list+1] = "Demeter"
    end
    if file_exists("Hades.lua") then 
        god_list[#god_list+1] = "Hades"
    end
    if file_exists("Hephaestus.lua") then 
        god_list[#god_list+1] = "Hephaestus"
    end
    if file_exists("Hermes.lua") then 
        god_list[#god_list+1] = "Hermes"
    end
    if file_exists("Prometheus.lua") then 
        god_list[#god_list+1] = "Prometheus"
    end
    if file_exists("Slave.lua") then 
        god_list[#god_list+1] = "Slave"
    end
    if #god_list > 0 then
        return god_list
    else
        return false
    end
end

function Draw_Top_Bar()
    term.setCursorPos(1, 1)
    term.setBackgroundColor(colors.orange)
    for i = 1, 51, 1 do
        term.write(" ")
    end
    term.setBackgroundColor(colors.black)
end

function Draw_Bottom_Nav(time)
    time = 20 - time
    term.setBackgroundColor(colors.black)
    term.setCursorPos(1, 19)
    term.clearLine()
    term.write(""..string.char(24).."   "..string.char(25).."   ENTER   |   AUTO-SELECT in ["..time.."]")
end

function Draw_Selection_Box(cur_selected, found_gods)
    local cur_cursor_y = 5
    term.setCursorPos(17, cur_cursor_y)
    term.setBackgroundColor(colors.white)
    for i = 1, 19, 1 do
        term.write(" ")
    end
    cur_cursor_y = cur_cursor_y + 1
    term.setCursorPos(17, cur_cursor_y)
    term.write(" ")
    term.setCursorPos(35, cur_cursor_y)
    term.write(" ")

    for i = 1, #found_gods, 1 do
        cur_cursor_y = cur_cursor_y + 1
        term.setBackgroundColor(colors.white)

        term.setCursorPos(17, cur_cursor_y)
        term.write(" ")
        term.setCursorPos(35, cur_cursor_y)
        term.write(" ")
        term.setBackgroundColor(colors.black)
        if i == cur_selected then
            term.setCursorPos(18, cur_cursor_y)
            term.write(string.char(16))
            term.setBackgroundColor(colors.orange)
            for i = 1, 15, 1 do
                term.write(" ")
            end
            term.setBackgroundColor(colors.black)
            term.write(string.char(17))
        end
        local cur_cursor_x = string.len(found_gods[i]) / 2
        cur_cursor_x = 26 - cur_cursor_x

        term.setCursorPos(cur_cursor_x, cur_cursor_y)
        term.write(found_gods[i])

    end

    term.setBackgroundColor(colors.white)
    cur_cursor_y = cur_cursor_y + 1
    term.setCursorPos(17, cur_cursor_y)
    term.write(" ")
    term.setCursorPos(35, cur_cursor_y)
    term.write(" ")
    cur_cursor_y = cur_cursor_y + 1
    term.setCursorPos(17, cur_cursor_y)
    term.write(" ")
    term.setCursorPos(35, cur_cursor_y)
    term.write(" ")

    term.setCursorPos(17, cur_cursor_y)
    for i = 1, 19, 1 do
        term.write(" ")
    end
    term.setBackgroundColor(colors.black)    

    term.setTextColor(colors.white)
    term.setCursorPos(1, 5)

    local _timer = os.startTimer(1)
    local time_counter = 0
    local while_test = true
    while while_test == true do
        Draw_Bottom_Nav(time_counter)
        local event, key, is_held = os.pullEvent()
        if event == "timer" then
            time_counter = time_counter + 1
            if time_counter > 20 then
                Project_to_Load = cur_selected
            while_test = false
            term.clear()
            return true
            else
                _timer = os.startTimer(1)
            end
        end
        if key == 265 then
            if cur_selected ~= 1 then
                cur_selected = cur_selected - 1
                return GodSelectionScreen(found_gods, cur_selected)
            end
        elseif key == 264 then
            if cur_selected < #found_gods then
                cur_selected = cur_selected + 1
                return GodSelectionScreen(found_gods, cur_selected)
            end
        elseif key == 257 then
            os.cancelTimer(_timer)
            print("cancelTimer")
            os.sleep(2)
            Project_to_Load = cur_selected
            while_test = false
            term.clear()
            return true
        end
    end
end

function GodSelectionScreen(found_gods, cur_selected)
    term.clear()
    Draw_Top_Bar()
    term.setCursorPos(16, 3)
    term.write("Please select Project")

    Draw_Selection_Box(cur_selected, found_gods)

end

function ShowStatus()
    term.setTextColor(colors.white)
    term.setCursorPos(1, 16)
    term.clearLine()
    term.write(""..string.char(16).."Searching System for Project Files")
    local boot_file = Read_Boot_save()
    if boot_file[1] ~= "0" then
        return boot_file[1]
    end
    local found_gods = FindGods()
    if found_gods == false then
        os.sleep(1)
        term.setTextColor(colors.red)
        term.setCursorPos(1, 16)
        term.clearLine()
        term.write(""..string.char(16).."Searching System for Project Files")
        Files_found = false
    else
        os.sleep(1)
        term.setTextColor(colors.green)
        term.setCursorPos(1, 16)
        term.clearLine()
        term.write(""..string.char(16).."Searching System for Project Files")
        Files_found = true
    end

    for i = 1, 13, 1 do
        os.sleep(0.2)
        term.scroll(1)
    end

    term.setCursorPos(1, 4)
    os.sleep(0.4)
    term.setTextColor(colors.white)
    if Files_found == false then
        term.write("Couldn't find Files")
        return false
    else
        term.write(""..#found_gods.." Project(s) found")
        os.sleep(2)

        if #found_gods == 1 then
            term.setCursorPos(1, 5)
            term.write("Automatically starting Project: "..found_gods[1].."")
            os.sleep(1)
            return found_gods[1]
        else
            GodSelectionScreen(found_gods, 1)
            return(found_gods[Project_to_Load])
        end

        
        

    end


end

LoadMountain(0.3)

local prj = ShowStatus()

if prj ~= false then
    ClosingMountain()
    term.clear()
    term.setCursorPos(1, 1)


    Write_Boot_save(prj)


    shell.execute(""..prj..".lua")
else
    term.setCursorPos(1, 6)
    term.write("Please copy Project Files onto the")
    term.setCursorPos(1, 7)
    term.setTextColor(colors.orange)
    term.write("Internal Storage")
    term.setTextColor(colors.white)
    term.setCursorPos(1, 8)
    term.write("and restart the PC")
    term.setCursorPos(1, 9)
end

