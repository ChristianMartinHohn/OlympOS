--Muss Reworked werden!!! ✓
--Aktuelle Hauptfunktion ist das Loggen von Turtles und deren Namen zuweisung

--TODO
--Ich muss mir dringend anschauen wie man eine Table in einer Datei speichert und die dann später wieder ausließt... wäre relativ wichtig für das Projekt
--Actually ziemlich nice von CoPilot aber KP ob das funktioniert --FUNKTIONIERT LES GOOO

Turtle_List = {}


local function save_table_to_file(tbl, filename)
    local file = io.open(filename, "w")
    if file then
        file:write(textutils.serialize(tbl))
        file:close()
    else
        error("Could not open file for writing: " .. filename)
    end
end

local function read_table_from_file(filename)
    local file = io.open(filename, "r")
    if file then
        local content = file:read("*a")
        file:close()
        return textutils.unserialize(content) or {} -- Leere Tabelle zurückgeben wenn Datei leer/ungültig
    else
        return {} -- Leere Tabelle zurückgeben wenn Datei nicht existiert
    end
end

peripheral.find("modem", rednet.open)

Title = {
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

local function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

function Check_Turtle_FuelChest()
    --Check ob genug fuel in FuelChest, sollte angeschlossen sein per Kabel
    --Bei zu wenig meldung an Zeus schicken
end

function Build_new_Turtle()
    --Send Command to Hephaestus(Turtle Constructor)
end

function Check_Active_Turtles() 
    --Check wie viele Turtles gerade Aktiv sind
    --Evtl evaluieren ob weitere gestarten werden sollen
end

function Load_old_Lists()
    if file_exists("Turtle_List.txt") then
        Turtle_List = read_table_from_file("Turtle_List.txt")
    else
        Turtle_List = {} -- Initialisiere leere Tabelle wenn Datei nicht existiert
    end
end

function Save_Turtle_List()
    save_table_to_file(Turtle_List, "Turtle_List.txt")
end

function Assign_Turtle_Mission() --WICHTIG muss noch überlegen wann welche Resource benötigt wird
    --Check wie viele Turtles gerade Aktiv sind
    --Wenn zu wenig Turtles in einer Categorie aktiv sind, return Mission
    return "IRON" --tmp
end

function Assign_Turtle_Area_Orientation() --WICHTIG muss noch überlegen wann welche Resource benötigt wird
    --Check wie viele Turtles gerade Aktiv sind
    --Wenn zu wenig Turtles in einer Categorie aktiv sind, return Mission
    return {height = 57, orientation = 0} --tmp height = Höhe auf der Ge-Mined werden soll, orientation = 0 Anzahl der Drehungen(Himmelsrichtung)
end

Turtle_List = {} -- Initialisiere Turtle_List vor dem Laden
Load_old_Lists()

os.setComputerLabel("Demeter")
PrintTitle()

while true do --warte auf Nachrichten Loop
    local id, message = rednet.receive()
    print(id)
    if (message) then
        if (message.Projekt == "Demeter") then --Check if message is from a Project Demeter member
            if message.Command == "REGISTER" then --Register a new Turtle
                local mission = Assign_Turtle_Mission()
                local awnser = {Mission = mission, HaO = Assign_Turtle_Area_Orientation()}
                rednet.send(id, awnser)
                local turtle = {Mission = mission}
                Turtle_List[id] = turtle
                Save_Turtle_List()
            elseif message.Command == "UPDATE" then --Update the Turtle List with the new Information
                Turtle_List[id] = message
                Save_Turtle_List()
            elseif message.Command == "REQUEST" then --Request Information from the Turtle List
                local awnser = Turtle_List[id]
                rednet.send(id, awnser)
            end
        end
    end
end 
