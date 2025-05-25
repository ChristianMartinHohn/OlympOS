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




local function Render_Screen()
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


while true do
    Render_Screen()
    sleep(60)
end
