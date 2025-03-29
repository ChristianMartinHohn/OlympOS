local start_screen = {
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
    '                                                   ',
    '                        -                          ',
    '                        -                          ',
    '                        -                          ',
    '                        -                          ',
    '                        -                          ',
    '                        -                          ',
    '                        -                          ',
    '                        -                          ',
}

--Hier müssen noch Infos eingefügt werden wie z.B. wie viele Turtels gerade aktiv sind und so
--Auch müssen wir evtl schauen ob wir hier einen exit button einbauen da man aktuell beide prozesse einzeln schließen muss

local function Render_Screen()
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

while true do
    Render_Screen()
    sleep(60)
end
