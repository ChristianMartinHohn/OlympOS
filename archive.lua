--Test für eine Fuelanzeige DEMETER > Turtle


Title = {
    '+                   ',
    '---------------------------------------',
    '                                       ',
    ' ##### #    # #####  ##### #     ##### ',
    '   #   #    # #    #   #   #     #     ',
    '   #   #    # #    #   #   #     #     ',
    '   #   #    # #####    #   #     ####  ',
    '   #   #    # #    #   #   #     #     ',
    '   #   ##  ## #    #   #   #     #     ',
    '   #    ####  #    #   #   ##### ##### ',
    '                                       ',
    '---------------------------------------',
    ''
}
VARIABLE = 0
Title = {
    '+                   ',
    '---------------------------------------',
    '                                       ',
    '                            #      #   ',
    '                            #      #   ',
    '    *        #      #   ',
    '                            #      #   ',
    '                            #      #   ',
    '   ,      #      #   ',
    '                            ########   ',
    '                                       ',
    '---------------------------------------',
    ''
}

function PrintTitle() --Gibt den Title aus. ACHTUNG manchmal weirder shit mit hintergrund farben also dannach idealer weise backgroundColor auf black wieder setzten.
    term.clear()
    for y_offset, line in pairs(Title) do
        term.setCursorPos(1, y_offset)
        for char in line:gmatch"." do
            if char == '#' then
                term.setBackgroundColor(colors.white)
            elseif char == '-' then
                term.setBackgroundColor(colors.green)
            elseif char == '+' then
                term.setBackgroundColor(colors.black)
                --term.write("DEMETER > Turtle")
                term.write(VARIABLE)
            elseif char == '*' then
                term.setBackgroundColor(colors.black)
                term.write("Fuel Remaining:")
            elseif char == ',' then
                term.setBackgroundColor(colors.black)
                term.write("Steps till return:")
            elseif char == '/' then
                term.setBackgroundColor(colors.gray)
            else
                term.setBackgroundColor(colors.black)
            end
            term.write(' ')
        end
    end
    term.setBackgroundColor(colors.black)
    --os.sleep(5)
end

--PrintTitle()

Turtle_List = {}
Turtle_List["1"] = {Fuel = "COAL", ["Steps"] = 100}
Turtle_List["2"] = {Fuel = "COAL", ["Steps"] = 100}
Turtle_List["3"] = {Fuel = "COAL", ["Steps"] = 100}
Turtle_List["4"] = {Fuel = "LAVA", ["Steps"] = 100}
Turtle_List["5"] = {Fuel = "LAVA", ["Steps"] = 100}
Turtle_List["6"] = {Fuel = "LAVA", ["Steps"] = 100}
Turtle_List["7"] = {Fuel = "NONE", ["Steps"] = 100}
Turtle_List["8"] = {Fuel = "NONE", ["Steps"] = 100}
Turtle_List["9"] = {Fuel = "NONE", ["Steps"] = 100}
Turtle_List["10"] = {Fuel = "NONE", ["Steps"] = 100}


-- Function to count the number of entries with Fuel as COAL
function countCoalFuelTurtles(turtleList)
    local count = 0
    for _, turtle in pairs(turtleList) do
        if turtle.Fuel == "COAL" then
            count = count + 1
        end
    end
    return count
end

-- Example usage
local coalCount = countCoalFuelTurtles(Turtle_List)
print("Number of turtles with COAL fuel: " .. coalCount)
