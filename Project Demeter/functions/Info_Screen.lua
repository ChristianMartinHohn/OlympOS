

Info_Screen = {}
Info_Screen.new = function ()
    local self = {}
    
    local start_screen = {
        '                                                   ',
        '                                                   ',
        '---------------------------------------------------',
        '                                                   ',
        '  #####   #### ##       ## #### ##### #### #####   ',
        '  #    #  #    # #     # # #      #   #    #    #  ',
        '  #     # #    # #     # # #      #   #    #    #  ',
        '  #     # ###  #  #   #  # ###    #   ###  #####   ',
        '  #     # #    #  #   #  # #      #   #    #    #  ',
        '  #    #  #    #   # #   # #      #   #    #    #  ',
        '  #####   #### #    #    # ####   #   #### #    #  ',
        '                                                   ',
        '---------------------------------------------------',
        '             +                                     ',
        '---------------------------------------------------',
        '                                                   ',
        '                                                   ',
        '                                                   ',
        '                                                   ',
        '                                                   ',
    }
    
    local function Start_Screen()
        term.clear()
        for y_offset, line in pairs(start_screen) do
            term.setCursorPos(1, y_offset)
            for char in line:gmatch"." do
                if char == '#' then
                    term.setBackgroundColor(colors.white)
                elseif char == '-' then
                    term.setBackgroundColor(colors.brown)
                elseif char == '+' then
                    term.write("Harvest, Grow and Nourish")
                elseif char == '/' then
                    term.setBackgroundColor(colors.gray)
                else
                    term.setBackgroundColor(colors.black)
                end
                term.write(' ')
            end
        end
        term.setBackgroundColor(colors.black)
    end

    self.Start_Screen = Start_Screen

    return self
end



