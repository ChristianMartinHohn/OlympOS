--Jupiter - 8
peripheral.find("modem", rednet.open)
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '#########################################################',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
    '                            #                            ',
}


local monitor = peripheral.find("monitor")
monitor.setBackgroundColour(colors.black)
monitor.clear()
monitor.setCursorPos(1, 1)
monitor.setTextScale(0.5)

for y_offset, line in pairs(Test_Screen) do
    monitor.setCursorPos(1, y_offset)
    for char in line:gmatch"." do
        if char == ' ' then
            monitor.setBackgroundColor(colors.white)
        else
            monitor.setBackgroundColor(colors.black)
        end
        monitor.write(' ')
        monitor.setBackgroundColor(colors.black)
    end
end