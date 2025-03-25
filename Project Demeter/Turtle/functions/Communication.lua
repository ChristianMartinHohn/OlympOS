require "Logger"
require "Progress"

local progress = Progress.new()
local logger = Logger.new()

Communication = {}
Communication.new = function ()
    local self = {}

    peripheral.find("modem", rednet.open)

    local function encrypt_demeter_message(message)
        local turtle_key = "5548224763"
        turtle_key = os.getComputerID() .. turtle_key .. os.day()
        local encrypted_message = ""
        for i = 1, #message do
            local byte = string.byte(message, i)
            encrypted_message = encrypted_message .. string.char(bit.bxor(byte, string.byte(turtle_key, i % #turtle_key + 1)))
        end
        return(encrypted_message)
    end

    local function decrypt_demeter_message(message)
        local demeter_key = "34821008614"
        demeter_key = os.day() .. demeter_key .. os.getComputerID()
        local decrypted_message = ""
        for i = 1, #message do
            local byte = string.byte(message, i)
            decrypted_message = decrypted_message .. string.char(bit.bxor(byte, string.byte(demeter_key, i % #demeter_key + 1)))
        end
        return(decrypted_message)
    end

    local function Setup_Demeter_Connection()
        local msg = "@ New Turtle Login" --@ als login, ! als error, ? als request, % als update .. ungefair so in der art
        local encrypted_msg = encrypt_demeter_message(msg)
        rednet.broadcast(encrypted_msg)
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
    self.Setup_Demeter_Connection = Setup_Demeter_Connection

    return self
end