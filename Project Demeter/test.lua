Slave = {
    '                                       ',
    '---------------------------------------',
    '                                       ',
    '  #####   #        #    #     #  ##### ',
    ' ##       #       # #   #     #  #     ',
    ' ##       #      #   #  ##   ##  #     ',
    '  #####   #     #     #  #   #   ####  ',
    '      ##  #     #######  ## ##   #     ',
    '      ##  #     #     #   # #    #     ',
    '  #####   ##### #     #    #     ##### ',
    '                                       ',
    '---------------------------------------',
    ''
}




function printFuelBar(cursor_y, current_level, desired_level)
    term.setCursorPos(1, 1)
    local progress = math.min(math.floor(FUEL_BAR * turtle.getFuelLevel() / desired_level), FUEL_BAR)
    term.write('[')
    for i = 1, progress do
        term.write('+')
    end
    for i = 1, FUEL_BAR - progress do
        term.write('-')
    end
    term.write('] ')
    term.write(tostring(current_level))
    term.write('/')
    term.write(tostring(desired_level))
end

--printFuelBar()