require "functions.Communication"
require "functions.Fuel"
require "functions.Logger"

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
            logger.log("error", "Mission file does not exist")
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
        local file = io.open("/Data/Turtle_mission.txt", "w")
        if file then
            file:write(textutils.serialize(table))
            file:close()
        else
            logger.error("Could not open file for writing")
        end
    end

    --Evtl hier in die function eine meldung an Demeter raus hauen, dann kann die SaveProgress funktion gespammed werden und erstens wird alles wichtige gespeichert und direkt auch an die zentrale geschickt.
    local function saveProgress(MineForResource, Travel_Distance, Base_Position, Turtle_State, DemeterID, Total_Distance_Traveled, First_activation)
        local saveData = { -- <- Hier bitte noch weiter Daten hinzufügen die nach einem Neustart wieder benötigt werden
            ["MineForResource"] = MineForResource,
            ["Travel_Distance"] = Travel_Distance,
            ["Base_Position"] = Base_Position,
            ["Turtle_State"] = Turtle_State,
            ["Fuel_Percent"] = fuel.getFuelPercent(),
            ["Current_Position"] = gps.locate(),
            ["Total_Distance_Traveled"] = Total_Distance_Traveled,
            ["First_activation"] = First_activation,
            ["DemeterID"] = DemeterID
        }
        --hier evtl Daten an Demeter senden?
        write_mission_file(saveData)
        communication.Send_Update(saveData)
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
            return false
        end
    end

    local function update_MineForResource(Resource)
        local old_mission_table = read_mission_file()
        if old_mission_table ~= false then
            local new_mission_table = {
                ["MineForResource"] = Resource,
                ["Travel_Distance"] = old_mission_table["Travel_Distance"],
                ["Base_Position"] = old_mission_table["Base_Position"],
                ["Turtle_State"] = old_mission_table["Turtle_State"],
                ["Fuel_Percent"] = old_mission_table["Fuel_Percent"],
                ["Current_Position"] = gps.locate(),
                ["Total_Distance_Traveled"] = old_mission_table["Total_Distance_Traveled"],
                ["First_activation"] = old_mission_table["First_activation"],
                ["DemeterID"] = old_mission_table["DemeterID"]
            }
            write_mission_file(new_mission_table)
            communication.Send_Update(new_mission_table)
        else
            logger.log("error", "Could not update MineForResource")
        end
    end

    local function update_Travel_Distance(Travel_Distance)
        local old_mission_table = read_mission_file()
        if old_mission_table ~= false then
            local new_mission_table = {
                ["MineForResource"] = old_mission_table["MineForResource"],
                ["Travel_Distance"] = Travel_Distance,
                ["Base_Position"] = old_mission_table["Base_Position"],
                ["Turtle_State"] = old_mission_table["Turtle_State"],
                ["Fuel_Percent"] = old_mission_table["Fuel_Percent"],
                ["Current_Position"] = gps.locate(),
                ["Total_Distance_Traveled"] = old_mission_table["Total_Distance_Traveled"],
                ["First_activation"] = old_mission_table["First_activation"],
                ["DemeterID"] = old_mission_table["DemeterID"]
            }
            write_mission_file(new_mission_table)
            communication.Send_Update(new_mission_table)
        else
            logger.log("error", "Could not update Travel_Distance")
        end
    end
    
    local function update_Total_Distance_Traveled(session_distance)
        local old_mission_table = read_mission_file()
        if old_mission_table ~= false then
            local new_mission_table = {
                ["MineForResource"] = old_mission_table["MineForResource"],
                ["Travel_Distance"] = old_mission_table["Travel_Distance"],
                ["Base_Position"] = old_mission_table["Base_Position"],
                ["Turtle_State"] = old_mission_table["Turtle_State"],
                ["Fuel_Percent"] = old_mission_table["Fuel_Percent"],
                ["Current_Position"] = gps.locate(),
                ["Total_Distance_Traveled"] = session_distance + old_mission_table["Travel_Distance"],
                ["First_activation"] = old_mission_table["First_activation"],
                ["DemeterID"] = old_mission_table["DemeterID"]
            }
            write_mission_file(new_mission_table)
            communication.Send_Update(new_mission_table)
        else
            logger.log("error", "Could not update Travel_Distance")
        end
    end

    local function update_Base_Position(Base_Position)
        local old_mission_table = read_mission_file()
        if old_mission_table ~= false then
            local new_mission_table = {
                ["MineForResource"] = old_mission_table["MineForResource"],
                ["Travel_Distance"] = old_mission_table["Travel_Distance"],
                ["Base_Position"] = Base_Position,
                ["Turtle_State"] = old_mission_table["Turtle_State"],
                ["Fuel_Percent"] = old_mission_table["Fuel_Percent"],
                ["Current_Position"] = gps.locate(),
                ["Total_Distance_Traveled"] = old_mission_table["Total_Distance_Traveled"],
                ["First_activation"] = old_mission_table["First_activation"],
                ["DemeterID"] = old_mission_table["DemeterID"]
            }
            write_mission_file(new_mission_table)
        else
            logger.log("error", "Could not update Base_Position")
        end
    end

    local function update_Turtle_State(Turtle_State)
        local old_mission_table = read_mission_file()
        if old_mission_table ~= false then
            local new_mission_table = {
                ["MineForResource"] = old_mission_table["MineForResource"],
                ["Travel_Distance"] = old_mission_table["Travel_Distance"],
                ["Base_Position"] = old_mission_table["Base_Position"],
                ["Turtle_State"] = Turtle_State,
                ["Fuel_Percent"] = old_mission_table["Fuel_Percent"],
                ["Current_Position"] = gps.locate(),
                ["Total_Distance_Traveled"] = old_mission_table["Total_Distance_Traveled"],
                ["First_activation"] = old_mission_table["First_activation"],
                ["DemeterID"] = old_mission_table["DemeterID"]
            }
            write_mission_file(new_mission_table)
            communication.Send_Update(new_mission_table)
        else
            logger.log("error", "Could not update Turtle_State")
        end
    end

    local function update_Fuel_Percent(Fuel_Percent)
        local old_mission_table = read_mission_file()
        if old_mission_table ~= false then
            local new_mission_table = {
                ["MineForResource"] = old_mission_table["MineForResource"],
                ["Travel_Distance"] = old_mission_table["Travel_Distance"],
                ["Base_Position"] = old_mission_table["Base_Position"],
                ["Turtle_State"] = old_mission_table["Turtle_State"],
                ["Fuel_Percent"] = Fuel_Percent,
                ["Current_Position"] = gps.locate(),
                ["Total_Distance_Traveled"] = old_mission_table["Total_Distance_Traveled"],
                ["First_activation"] = old_mission_table["First_activation"],
                ["DemeterID"] = old_mission_table["DemeterID"]
            }
            write_mission_file(new_mission_table)
            communication.Send_Update(new_mission_table)
        else
            logger.log("error", "Could not update Fuel_Percent")
        end
    end

    local function update_Current_Position()
        local old_mission_table = read_mission_file()
        if old_mission_table ~= false then
            local new_mission_table = {
                ["MineForResource"] = old_mission_table["MineForResource"],
                ["Travel_Distance"] = old_mission_table["Travel_Distance"],
                ["Base_Position"] = old_mission_table["Base_Position"],
                ["Turtle_State"] = old_mission_table["Turtle_State"],
                ["Fuel_Percent"] = old_mission_table["Fuel_Percent"],
                ["Current_Position"] = gps.locate(),
                ["Total_Distance_Traveled"] = old_mission_table["Total_Distance_Traveled"],
                ["First_activation"] = old_mission_table["First_activation"],
                ["DemeterID"] = old_mission_table["DemeterID"]
            }
            write_mission_file(new_mission_table)
            communication.Send_Update(new_mission_table)
        else
            logger.log("error", "Could not update Current_Position")
        end
    end

    local function set_First_activation()
        local date_time = os.date("%F %T")
        local old_mission_table = read_mission_file()
        if old_mission_table ~= false then
            local new_mission_table = {
                ["MineForResource"] = old_mission_table["MineForResource"],
                ["Travel_Distance"] = old_mission_table["Travel_Distance"],
                ["Base_Position"] = old_mission_table["Base_Position"],
                ["Turtle_State"] = old_mission_table["Turtle_State"],
                ["Fuel_Percent"] = old_mission_table["Fuel_Percent"],
                ["Current_Position"] = gps.locate(),
                ["Total_Distance_Traveled"] = old_mission_table["Total_Distance_Traveled"],
                ["First_activation"] = date_time,
                ["DemeterID"] = DemeterID
            }
            write_mission_file(new_mission_table)
        else
            logger.log("error", "Could not update DemeterID")
        end
    end

    local function update_DemeterID(DemeterID)
        local old_mission_table = read_mission_file()
        if old_mission_table ~= false then
            local new_mission_table = {
                ["MineForResource"] = old_mission_table["MineForResource"],
                ["Travel_Distance"] = old_mission_table["Travel_Distance"],
                ["Base_Position"] = old_mission_table["Base_Position"],
                ["Turtle_State"] = old_mission_table["Turtle_State"],
                ["Fuel_Percent"] = old_mission_table["Fuel_Percent"],
                ["Current_Position"] = gps.locate(),
                ["Total_Distance_Traveled"] = old_mission_table["Total_Distance_Traveled"],
                ["First_activation"] = old_mission_table["First_activation"],
                ["DemeterID"] = DemeterID
            }
            write_mission_file(new_mission_table)
        else
            logger.log("error", "Could not update DemeterID")
        end
    end

    -- Public Methods
    self.saveProgress = saveProgress
    self.read_mission_file = read_mission_file

    self.update_MineForResource = update_MineForResource
    self.update_Travel_Distance = update_Travel_Distance
    self.update_Total_Distance_Traveled = update_Total_Distance_Traveled
    self.update_Base_Position = update_Base_Position
    self.update_Turtle_State = update_Turtle_State
    self.update_Fuel_Percent = update_Fuel_Percent
    self.update_Current_Position = update_Current_Position
    self.set_First_activation = set_First_activation
    self.update_DemeterID = update_DemeterID
    return self
end
