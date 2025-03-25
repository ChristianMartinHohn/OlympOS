
Communication = {}
Communication.new = function ()
    local self = {}

    local function decrypt_turtle_message(message, turtle_id)
        local turtle_key = "5548224763"
        turtle_key = turtle_id .. turtle_key .. os.day()
        local decrypted_message = ""
        for i = 1, #message do
            local byte = string.byte(message, i)
            decrypted_message = decrypted_message .. string.char(bit.bxor(byte, string.byte(turtle_key, i % #turtle_key + 1)))
        end
        return(decrypted_message)
    end

    local function encrypt_turtle_message(message)
        local turtle_key = "34821008614"
        turtle_key = os.day() .. demeter_key .. os.getComputerID()
        local encrypted_message = ""
        for i = 1, #message do
            local byte = string.byte(message, i)
            encrypted_message = encrypted_message .. string.char(bit.bxor(byte, string.byte(turtle_key, i % #turtle_key + 1)))
        end
        return(encrypted_message)
    end

    self.decrypt_turtle_message = decrypt_turtle_message
    self.encrypt_turtle_message = encrypt_turtle_message

    return self
end