require "functions.Logger"
require "functions.Screen_helper"
--require "Logger"
--require "Screen_helper"


local logger = Logger.new()
local screen_helper = Screen_helper.new()

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
        screen_helper.draw_demeter_seach_screen(0, 1)
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
        else
            logger.log("error", "Demeter Connection could not be established")
            return false
        end
    end

    local function Send_Update(demeter_message)
        if Offline_Mode == true then
            logger.log("info", "Offline Mode. No Update sent to Demeter")
            return false
        else
            if demeter_message ~= nil then
                logger.log("info", "Sending Update to Demeter")
                rednet.send(demeter_message["DemeterID"], demeter_message)
            else
                logger.log("error", "No Message to send")
                return false
            end  
        end

    end

    local function check_modem_in_inventory()
        for i = 1, 16 do
            sleep(0.1)
            screen_helper.draw_modem_seach_screen(nil, i, 16)
            turtle.select(i)
            if turtle.getItemDetail() and turtle.getItemDetail().name == "computercraft:wireless_modem_advanced" then
                turtle.equipLeft()
                if turtle.getItemDetail() and turtle.getItemDetail().name == "minecraft:diamond_pickaxe" then
                    turtle.equipRight()
                end
                turtle.select(1)
                screen_helper.draw_modem_seach_screen(true, 16, 16)
                sleep(2)
                return true
            end
        end
        turtle.select(1)
        screen_helper.draw_modem_seach_screen(false, 16, 16)
        sleep(2)
        --hier evtl fragen ob ohne Modem weiter gemacht wird
        return false
    end
    
    local function setup_locate_modem()
        screen_helper.draw_modem_seach_screen(nil, 1, 16)
        local modem = peripheral.find("modem")
        if modem == nil then
            if check_modem_in_inventory() then
                return true
            else
                logger.log("error", "No modem found")
                return false
            end
        else
            screen_helper.draw_modem_seach_screen(true, 16, 16)
            peripheral.find("modem", rednet.open)
            sleep(2)
            return true
        end
    end

    -- Public Methods
    self.Send_Update = Send_Update
    self.Setup_Demeter_Connection = Setup_Demeter_Connection
    self.setup_locate_modem = setup_locate_modem
    return self
end

