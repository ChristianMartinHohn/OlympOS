os.setComputerLabel("Hermes")

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
    ' #                      # ',
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
    ' #                      # ',
    ' ######################## ',
    '                          ',
    '                          ',
    '                          ',
}



local function Opening_Animation()
    for i = 1, 3, 1 do
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
        os.sleep(0.5)
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
        os.sleep(1)
    end
end

Opening_Animation()


--evtl hier eine locale Datenbank einbauen
--genau so wie mehrere Pages die dann die Info anzeigen