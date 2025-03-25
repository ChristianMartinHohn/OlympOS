peripheral.find("modem", rednet.open)

local id, message = rednet.receive()
--print(("Computer %d sent message %s"):format(id, message))

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

print(decrypt_turtle_message(message, id))