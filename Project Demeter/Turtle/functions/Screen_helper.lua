Screen_helper = {}
Screen_helper.new = function ()
    local self = {}

    Test_Screen = {
        '+                   ',
        '---------------------------------------',
        '                                       ',
        '                                       ',
        '       #                   #           ',
        '       #                   #           ',
        '               ######                  ',
        '                                       ',
        '         %',
        '                                       ',
        '                                       ',
        '                                       ',
        ''
    }

    Modem_Search_Screen = {
        '+                   ',
        '---------------------------------------',
        '              3         3              ',
        '             3           3             ',
        '            3   2     2   3            ',
        '           3   2   1   2   3           ',
        '           3   2   1   2   3           ',
        '            3   2     2   3            ',
        '             3           3             ',
        '&',
        '%',
        '---------------------------------------',
        ''
    }

    local function draw_progress_bar(cur, max)
        local cursor_x, cursor_y = term.getCursorPos()
        local bar_length = 38
        bar_length = bar_length - cursor_x
        local progress = math.floor((cur / max) * bar_length)
        term.write("[")
        for i = 1, progress do
            term.write("=")
        end

        term.setCursorPos(39, cursor_y)
        term.write("]")
    end

    local function draw_demeter_seach_screen(iteration, max, objective)
        local color_list = {colors.white, colors.orange, colors.white, colors.white}
        term.clear()
        for y_offset, line in pairs(Modem_Search_Screen) do
            term.setCursorPos(1, y_offset)
            for char in line:gmatch"." do
                if char == '1' then
                    term.setBackgroundColor(color_list[((iteration + 2) % 3) + 1])
                elseif char == '2' then
                    term.setBackgroundColor(color_list[((iteration + 1) % 3) + 1])
                elseif char == '3' then
                    term.setBackgroundColor(color_list[((iteration) % 3) + 1] )
                elseif char == '+' then
                    term.write("Turtle: ")
                    term.write(os.getComputerID())
                    term.write(" - " .. objective .. "")
                elseif char == '&' then
                    term.write("Progress:")
                elseif char == '%' then
                    draw_progress_bar(iteration, max)
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

    local function draw_modem_seach_screen(found, iteration, max)
        local color = colors.white
        if found == true then
            color = colors.green
        elseif found == false then
            color = colors.red
        end
        term.clear()
        for y_offset, line in pairs(Modem_Search_Screen) do
            term.setCursorPos(1, y_offset)
            for char in line:gmatch"." do
                if char == '1' then
                    term.setBackgroundColor(color)
                elseif char == '2' then
                    term.setBackgroundColor(color)
                elseif char == '3' then
                    term.setBackgroundColor(color)
                elseif char == '+' then
                    term.write("Turtle: ")
                    term.write(os.getComputerID())
                    term.write(" - Seraching for Modem")
                elseif char == '&' then
                    term.write("Progress:")
                elseif char == '%' then
                    draw_progress_bar(iteration, max)
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

    local function draw_test_screen(cur, max)
        term.clear()
        for y_offset, line in pairs(Test_Screen) do
        term.setCursorPos(1, y_offset)
        for char in line:gmatch"." do
            if char == '#' then
                term.setBackgroundColor(colors.white)
            elseif char == '%' then
                draw_progress_bar(cur, max)
            else
                term.setBackgroundColor(colors.black)
            end
            term.write(' ')
            term.setBackgroundColor(colors.black)
        end
    end
    term.setBackgroundColor(colors.black)
    end

    local test = function()
        for i = 1, 10 do
            draw_modem_seach_screen(i, 10, "Searching for Modem")
            sleep(1)
        end
        
    end

    self.draw_modem_seach_screen = draw_modem_seach_screen
    self. test = test

    return self
end