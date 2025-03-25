Database = {}
Database.new = function()
    local self = {}

    local function create_database()
        fs.makeDir("/Database")
        return true
    end

    local function check_database_exists()
        if fs.isDir("/Database") then
            return true
        else
            create_database()
        end
    end

    local function check_turtle_in_database(Turtle_ID)
        if check_database_exists() then
            if fs.exists("/Database/" .. Turtle_ID) then
                print("already exists")
                return true
            else
                print("does not exist")
                return false
            end
        end
    end

    local function create_turtle_database(Turtle_ID)
        if check_turtle_in_database(Turtle_ID) then
            print("Turtle already in Database")
            return false
        else
            print("Creating Database for Turtle")
            fs.makeDir("/Database/" .. Turtle_ID)
            local turtle_file = io.open("/Database/" .. Turtle_ID .. "/Turtle_".. Turtle_ID .. ".txt", "w")
            return true
        end
        
    end

    self.check_database_exists = check_database_exists
    self.check_turtle_in_database = check_turtle_in_database
    self.create_turtle_database = create_turtle_database

    return self
end

local database = Database.new()
database.create_turtle_database(1)
