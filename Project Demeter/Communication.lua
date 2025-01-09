require "Logger"

Comms = {}
Comms.new = function ()
    local self = {}
    
    local logger = Logger.new()
    peripheral.find("modem", rednet.open)

    local function Send_Update(custom_transmittion)
        local msg = self.create_msg(custom_transmittion)
        rednet.send(DemeterID, msg)
    end

    function self.create_msg(custom_transmittion)
        if custom_transmittion == nil then
            custom_transmittion = ""
        end
        local demeter_message = {Projekt = "Demeter", 
                                    Command = "UPDATE", --UPDATE, EMERGENCY, INFO
                                    Fuel = getFuelPercent(), 
                                    Turtle_State =  Turtle_State, 
                                    Base_Position = Base_Position, 
                                    Travel_Distance = Travel_Distance, 
                                    Target_Resource = MineForResource, 
                                    Cur_Pos = gps.locate(),
                                    Message = custom_transmittion
                                    }
        return demeter_message
        
    end

    -- Public Methods
    self.Send_Update = Send_Update

    return self
end