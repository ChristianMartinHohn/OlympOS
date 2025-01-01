Title = {
    '                          ',
    '                          ',
    '                          ',
    '                          ',
    '                          ',
    '                          ',
    ' ######################## ',
    ' # #                  # # ',
    ' #   #              #   # ',
    ' #     #          #     # ',
    ' #       #      #       # ',
    ' #         #  #         # ',
    ' #          ##          # ',
    ' #                      # ',
    ' #                      # ',
    ' #   +  # ',
    ' ######################## ',
    '                          ',
    '                          ',
    '                          ',
}
Title2 = {
    '            ##            ',
    '          #    #          ',
    '        #        #        ',
    '      #            #      ',
    '    #                #    ',
    '  #                    #  ',
    ' ######################## ',
    ' # #################### # ',
    ' #   ################   # ',
    ' #     ############     # ',
    ' #       ########       # ',
    ' #         ####         # ',
    ' #          ##          # ',
    ' #                      # ',
    ' #                      # ',
    ' #   +  # ',
    ' ######################## ',
    '                          ',
    '                          ',
    '                          ',
}



os.setComputerLabel("Demeter")


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
                term.write("Emissary of Gods")
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

function PrintTitle2()
    term.clear()
    for y_offset, line in pairs(Title2) do
        term.setCursorPos(1, y_offset)
        for char in line:gmatch"." do
            if char == '#' then
                term.setBackgroundColor(colors.white)
            elseif char == '-' then
                term.setBackgroundColor(colors.brown)
            elseif char == '+' then
                term.write("Emissary of Gods")
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
    PrintTitle()
    os.sleep(2)
    PrintTitle2()
    os.sleep(2)
end

