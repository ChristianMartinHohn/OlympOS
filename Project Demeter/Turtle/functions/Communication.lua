require "functions.Logger"
require "functions.Screen_helper"
--require "Logger"
--require "Screen_helper"


local logger = Logger.new()
local screen_helper = Screen_helper.new()

Communication = {}
Communication.new = function()
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

    local function get_gps_position()
        if GPS_Enabled and not Offline_Mode then
            local x, y, z = gps.locate()
            if x and y and z then
                return {x = x, y = y, z = z}
            else
                logger.log("error", "GPS location could not be determined")
                return nil
            end
        else
            logger.log("error", "GPS is not enabled")
            return nil
        end
    end

    local function ping_Demeter()
        rednet.send(DemeterID, "Ping", "PING")
        local id, message, protocol = rednet.receive(5)
        if id == DemeterID and message and protocol == "PING" then
            logger.log("info", "Demeter is online")
            return true
        else
            logger.log("error", "Demeter is offline or not responding")
            return false
        end
        return
    end

    

    -- check ATLAS Connection
    -- check DEMETER Connection

    local function setup_Demeter_Connection()
        screen_helper.draw_demeter_seach_screen(0, 1)
        local msg = "@ New Turtle Login" --@ als login, ! als error, ? als request, % als update .. ungefair so in der art
        local encrypted_msg = encrypt_demeter_message(msg)
        rednet.broadcast(encrypted_msg, "T_LOGIN")
        local id, message = rednet.receive(nil, 10)
        if message ~= nil then
            local decrypted_message = decrypt_demeter_message(message)
            if string.find(decrypted_message, "@") then
                DemeterID = id
                --progress.progress_update_DemeterID(id)
                logger.log("info", "Demeter Connection established")
                return true
            else
                logger.log("error", "Demeter Connection could not be established")
                return false
            end
        else
            logger.log("error", "Demeter Connection could not be established")
            return false
        end
    end

    local function Send_Update(message_type, demeter_message)
        if not Offline_Mode then
            if demeter_message ~= nil then
                demeter_message["MessageType"] = message_type
                logger.log("info", "Sending Update to Demeter")
                rednet.send(DemeterID, demeter_message, "T_UPDATE")
            else
                logger.log("error", "No Message to send")
                return false
            end  
        else
            logger.log("info", "Offline Mode. No Update sent to Demeter")
            return false
        end


    end

    local function Send_Emergency(reason, fuel_percent)
        if not Offline_Mode then
            if reason ~= nil then
                logger.log("info", "Sending Emergency Message to Demeter")
                local message = {
                    ["Emergency_type"] = reason,
                    ["Fuel_Percent"] = fuel_percent,
                    ["Current_Position"] = get_gps_position(),
                    ["MessageType"] = "Emergency"
                }
                rednet.send(DemeterID, message, "T_EMERGENCY")
                return true
            else
                logger.log("error", "No Message to send")
                return false
            end
        else
            logger.log("info", "Offline Mode. No Emergency Message sent to Demeter")
            return false
        end
    end

    -- Public Methods
    self.Send_Update = Send_Update
    self.setup_Demeter_Connection = setup_Demeter_Connection
    self.Send_Emergency = Send_Emergency
    self.ping_Demeter = ping_Demeter
    return self
end