require "Logger"
require "Progress"

local progress = Progress.new()
local logger = Logger.new()

Communication = {}
Communication.new = function ()
    local self = {}

    peripheral.find("modem", rednet.open)

    local function Setup_Demeter_Connection()
        
    end

    local function Send_Update()
        local mission = progress.read_mission_file()
        if mission ~= false then
            logger.log("info", "Sending Update to Demeter")
            local demeter_message = {
                ["MineForResource"] = mission["MineForResource"],
                ["Travel_Distance"] = mission["Travel_Distance"],
                ["Base_Position"] = mission["Base_Position"],
                ["Turtle_State"] = mission["Turtle_State"],
                ["Fuel_Percent"] = mission["Fuel_Percent"],
                ["Current_Position"] = mission["Current_Position"]
            }
            rednet.send(mission["DemeterID"], demeter_message)
        else
            logger.log("error", "Could not send Update to Demeter")
            return false
        end  
    end


    -- Public Methods
    self.Send_Update = Send_Update

    return self
end