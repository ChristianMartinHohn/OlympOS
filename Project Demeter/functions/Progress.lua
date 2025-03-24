require "Communication"
require "Fuel"
require "Logger"

local communication = Communication.new()
local fuel = Fuel.new()
local logger = Logger.new()

Progress = {}
Progress.new = function()
    local self = {}

    local function check_mission_file_exists()
        local file = io.open("/Data/Turtle_mission.txt", "r")
        if file then
            return true
        else
            return false
        end
    end

    local function setup_mission_file()
        if check_mission_file_exists() then
            return false
        else
            local file = io.open("/Data/Turtle_mission.txt", "w")
            if file then
                return true
            else
                return false
            end
        end
    end

    local function write_mission_file(table) --Hier wird die Mission in eine Datei geschrieben wichtig ist das eine Table als input genommen wird
        local file = io.open("Turtle_mission.txt", "w")
        if file then
            file:write(textutils.serialize(table))
            file:close()
        else
            error("Could not open file for writing")
        end
    end

    --Evtl hier in die function eine meldung an Demeter raus hauen, dann kann die SaveProgress funktion gespammed werden und erstens wird alles wichtige gespeichert und direkt auch an die zentrale geschickt.
    local function saveProgress(MineForResource, Travel_Distance, Base_Position, Turtle_State, DemeterID)
        local saveData = { -- <- Hier bitte noch weiter Daten hinzufügen die nach einem Neustart wieder benötigt werden
            ["MineForResource"] = MineForResource,
            ["Travel_Distance"] = Travel_Distance,
            ["Base_Position"] = Base_Position,
            ["Turtle_State"] = Turtle_State,
            ["Fuel_Percent"] = fuel.getFuelPercent(),
            ["Current_Position"] = gps.locate(),
            ["DemeterID"] = DemeterID
        }
        write_mission_file(saveData)
    end

    local function read_mission_file()
        if check_mission_file_exists() then
            local file = io.open("/Data/Turtle_mission.txt", "r")
            if file then
                local content = file:read("*a")
                file:close()
                return textutils.unserialize(content)
            else
                logger.log("error", "Could not open file for reading")
                return false
            end
        else
            setup_mission_file()
        end
    end

    

    local function test()
        print("sus")
    end

    -- Public Methods
    self.saveProgress = saveProgress
    self.read_mission_file = read_mission_file
    self.test = test

    return self

    
end
