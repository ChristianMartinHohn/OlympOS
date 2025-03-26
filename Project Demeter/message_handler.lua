require "functions.Communication"
require "functions.Database"

local communication = Communication.new()
local database = Database.new()

local id = tonumber(arg[1])
local message = arg[2]
if message ~= nil then
    local decrypted_message = communication.decrypt_turtle_message(message, id)
    if string.find(decrypted_message, "@") then
        print("The message contains the '@' character.")
        database.update_turtle_in_database(id, decrypted_message)
        communication.awnser_turtle_login(id)
    elseif string.find(decrypted_message, "!") then
        print("The message contains the '!' character.")
    end
    print(decrypted_message)
else
    print("No message received.")
end




