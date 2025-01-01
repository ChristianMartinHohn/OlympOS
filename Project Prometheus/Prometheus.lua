--Jupiter - 8
peripheral.find("modem", rednet.open)

local id, message = rednet.receive()
print(("Computer %d sent message %s"):format(id, message))