require "functions.Logger"
--require "Progress"

--local progress = Progress.new()
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
        local id, message = rednet.receive(nil, 10)
        if message ~= nil then
            local decrypted_message = decrypt_demeter_message(message)
            if string.find(decrypted_message, "@") then
                --progress.progress_update_DemeterID(id)
                logger.log("info", "Demeter Connection established")
                return true
            else
                logger.log("error", "Demeter Connection could not be established")
                return false
            end
            logger.log("info", "Demeter Connection established")
            return true
        else
            logger.log("error", "Demeter Connection could not be established")
            return false
        end
    end

    local function Send_Update(demeter_message)
        if demeter_message ~= nil then
            logger.log("info", "Sending Update to Demeter")
            rednet.send(demeter_message["DemeterID"], demeter_message)
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