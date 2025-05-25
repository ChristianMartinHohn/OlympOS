require "functions.Atlas_DB"

local database = Atlas_DB.new()

os.setComputerLabel("ATLAS")

peripheral.find("modem", rednet.open)


local function lookup_Atlas_num()
    local atlas_list = {rednet.lookup("ATLAS")}
    if not atlas_list then
        rednet.host("ATLAS", "ATLAS" .. 1)
    else
        if #atlas_list > 4 then
            print("Too many ATLAS instances running, exiting...")
            exit()
        else
            for i = 1, #atlas_list do
                if atlas_list[i] == os.getComputerID() then
                    rednet.unhost("ATLAS")
                    ATLAS_NUM = i
                    rednet.host("ATLAS", "ATLAS" .. i)
                    database.write_db_file()
                    return true
                end
            end
            rednet.host("ATLAS", "ATLAS" .. (#atlas_list + 1))
            ATLAS_NUM = #atlas_list + 1
            database.write_db_file()
            return true
        end
    end
end



function Ask_Cords()
    --PrintTitle()
    term.clear()
    term.setCursorPos(15, 17)
    term.write("Please Enter X Cordinate:")
    term.setCursorPos(24, 18)
    Cordinates.x = read()
    --PrintTitle()
    term.clear()
    term.setCursorPos(15, 17)
    term.write("Please Enter Y Cordinate:")
    term.setCursorPos(24, 18)
    Cordinates.y = read()
    --PrintTitle()
    term.clear()
    term.setCursorPos(15, 17)
    term.write("Please Enter Z Cordinate:")
    term.setCursorPos(24, 18)
    Cordinates.z = read()
    database.write_db_file()
end

function Boot()
    Cordinates = {x = 0, y = 0, z = 0}
    ATLAS_NUM = 0

    local awnser = database.read_db_file()
    if awnser then
        Cordinates = awnser.Cordinates
        ATLAS_NUM = awnser.ATLAS_NUM
    end

    if Cordinates.x == 0 and Cordinates.y == 0 and Cordinates.z == 0 then
        Ask_Cords()
    end

    if ATLAS_NUM == 0 then
        lookup_Atlas_num()
    end

    local shell_id = shell.openTab("Info_Screen")

    shell.switchTab(shell_id)

    shell.run("gps", "host", Cordinates.x, Cordinates.y, Cordinates.z)
end

p1, p2 = peripheral.find("modem")

if p1 == nil then
    local txt = "A Modem is missing"
    local field_lenght = (28 - (string.len(txt)/2))
    Cords_Set = true
    PrintTitle()
    term.setCursorPos(field_lenght, 17)
    term.write(txt)
    term.setCursorPos(field_lenght +1, 1)
else
    Boot()
end
