peripheral.find("modem", rednet.open)

Slave_List = {}




print("waiting for msf")
local id, message = rednet.receive()
    if (message.Project == "Demeter") then
        Slave_List[id] = message
        rednet.send(id, #Slave_List)
    end

print(Slave_List)