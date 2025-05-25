require "functions.Communication"
require "functions.Database"

local communication = Communication.new()
local database = Database.new()

local id = tonumber(arg[1])
local message = arg[2]
local protocol = arg[3]
if protocol == "PING" then
    communication.awnser_ping(id)
    
elseif protocol == "T_LOGIN" then
    if message ~= nil then
        local decrypted_message = communication.decrypt_turtle_message(message, id)
        if string.find(decrypted_message, "@") then
            database.update_turtle_in_database(id, decrypted_message)
            communication.awnser_turtle_login(id)
        elseif string.find(decrypted_message, "!") then
        end
    else
        print("No message received.")
    end
else
    print("Received message with unknown protocol: " .. protocol)
end









