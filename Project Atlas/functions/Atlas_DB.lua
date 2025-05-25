Atlas_DB = {}
Atlas_DB.new = function()
    local self = {}

    local function db_file_exists()
        local f = io.open("Database.txt", "r")
        if f then 
            f:close()
            return true
        end
        return false
    end

    local function read_db_file()
        if db_file_exists() then
            local file = io.open("Database.txt", "r")
            if file then
                local content = file:read("*a")
                file:close()
                return textutils.unserialize(content)
            else
                return false
            end
        else
            local f = io.open("Database.txt", "w")
            if f then 
                f:close()
                return false
            end
        end
    end

    local function write_db_file()
        local file = io.open("Database.txt", "w")
        if file then
            local tmp_table = {
                ["Cordinates"] = Cordinates,
                ["ATLAS_NUM"] = ATLAS_NUM
            }
            file:write(textutils.serialize(tmp_table))
            file:close()
        end
    end

    self.db_file_exists = db_file_exists
    self.read_db_file = read_db_file
    self.write_db_file = write_db_file

    return self
end
