Title = {
    '                                                ',
    '---------------------------------------------------',
    '                                                ',
    '  #####   #### ##       ## #### ##### #### #####',
    '  #    #  #    # #     # # #      #   #    #    #',
    '  #     # #    # #     # # #      #   #    #    #',
    '  #     # ###  #  #   #  # ###    #   ###  #####',
    '  #     # #    #  #   #  # #      #   #    #    #',
    '  #    #  #    #   # #   # #      #   #    #    #',
    '  #####   #### #    #    # ####   #   #### #    #',
    '                                                ',
    '---------------------------------------------------',
    '              +           ',
    '---------------------------------------------------',
    '                                                ',
    '                        /                        ',
    '                        /                        ',
    '                        /                        ',
    ''
}




function PrintTitle()
    term.clear()
    for y_offset, line in pairs(Title) do
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

PrintTitle()

--while true do
--    local event, button, x, y = os.pullEvent("mouse_click")
--    print(("The mouse button %s was pressed at %d, %d"):format(button, x, y))
--  end