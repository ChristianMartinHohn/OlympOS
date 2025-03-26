Database = {}
Database.new = function()
    local self = {}

    local function create_database_folder()
        fs.makeDir("/Database")
        return true
    end

    local function create_turtle_folder(Turtle_ID)
        fs.makeDir("/Database/" .. Turtle_ID)
        return true
    end

    local function create_turtle_file(Turtle_ID)
        local file = io.open("/Database/".. Turtle_ID .."/Turtle_".. Turtle_ID ..".txt", "w")
        file:close()
        return true
    end

    local function check_database_folder_exists()
        if fs.isDir("/Database") then
            return true
        else
            return create_database_folder()
        end
    end

    local function check_turtle_file_exists(Turtle_ID)
        local file = io.open("/Database/".. Turtle_ID .."/Turtle_".. Turtle_ID ..".txt", "r")
        if file then
            return true
        else
            return false
        end
    end

    local function check_turtle_in_database(Turtle_ID)
        if check_database_folder_exists() then
            if fs.exists("/Database/" .. Turtle_ID) then
                if check_turtle_file_exists(Turtle_ID)then
                    return true
                else
                    return false
                end
            else
                return false
            end
        end
    end

    local function setup_turtle_in_database(Turtle_ID)
        if check_turtle_in_database(Turtle_ID) then
            return true
        else
            create_turtle_folder(Turtle_ID)
            create_turtle_file(Turtle_ID)
            return true
        end
    end

    -- die function updatet die Datenbank mit den neuen Daten, dabei wird eine Datei erstellt sollte dies fehlen und die alten daten werden auch immer überschrieben da davon auszugehen ist das die neuen Daten wichtiger sind
    local function update_turtle_in_database(Turtle_ID, data)
        if check_turtle_in_database(Turtle_ID) then
            local file = io.open("/Database/".. Turtle_ID .."/Turtle_".. Turtle_ID ..".txt", "w")
            if file then
                file:write(textutils.serialize(data))
                file:close()
                return true
            else
                return false
            end
        else
            create_turtle_folder(Turtle_ID)
            create_turtle_file(Turtle_ID)
            return update_turtle_in_database(Turtle_ID, data)
        end
    end


    local function read_db_tmp(Turtle_ID)
        if check_turtle_in_database(Turtle_ID) then
            local file = io.open("/Database/".. Turtle_ID .."/Turtle_".. Turtle_ID ..".txt", "r")
            if file then
                local content = file:read("*a")
                file:close()
                return textutils.unserialize(content)
            else
                return false
            end
        else
            return false
        end
    end

    -- hier muss noch das Dantenbank lesen eingeführt werden

    self.update_turtle_in_database = update_turtle_in_database
    self.setup_turtle_in_database = setup_turtle_in_database
    self.read_db_tmp = read_db_tmp

    return self
end