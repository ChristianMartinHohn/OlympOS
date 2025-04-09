require "functions.NodeChecker"
require "functions.Logger"
require "functions.Pathfinder"

Move = {}
Move.new = function ()
    local self = {}

    local logger = Logger.new()
    local nodeChecker = NodeChecker.new()

    local pathfinder = Pathfinder.new()
    

    local function down(wp_sys_enabled)
        if wp_sys_enabled == nil or wp_sys_enabled == true then
            wp_sys_enabled = true
        end
        turtle.digDown()
        
        a1, a2 = turtle.down()
        if a1 == false then
            logger.log("error", a2)
            return false
        end

        Travel_Distance = Travel_Distance - 1
        Session_Distance_Tracker = Session_Distance_Tracker + 1
        if wp_sys_enabled then
            pathfinder.add_waypoint("down")
        end
    end

    local function up(wp_sys_enabled)
        if wp_sys_enabled == nil or wp_sys_enabled == true then
            wp_sys_enabled = true
        end
        turtle.digUp()
        
        a1, a2 = turtle.up()
        if a1 == false then
            logger.log("error", a2)
            return false
        end
        
        Travel_Distance = Travel_Distance - 1
        Session_Distance_Tracker = Session_Distance_Tracker + 1
        if wp_sys_enabled then
            pathfinder.add_waypoint("up")
        end
    end
    
    local function forward(wp_sys_enabled)
        if wp_sys_enabled == nil or wp_sys_enabled == true then
            wp_sys_enabled = true
        end
        turtle.dig()
        self.move()

        if wp_sys_enabled then
            pathfinder.add_waypoint("forward")
        end
    end

    local function back(wp_sys_enabled)
        if wp_sys_enabled == nil or wp_sys_enabled == true then
            wp_sys_enabled = true
        end
        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()

        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()

        turtle.dig()
        self.move()

        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()
        
        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()

        if wp_sys_enabled then
            pathfinder.add_waypoint("back")
        end
    end

    local function left(wp_sys_enabled)
        if wp_sys_enabled == nil or wp_sys_enabled == true then
            wp_sys_enabled = true
        end
        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()

        turtle.dig()
        self.move()

        turtle.turnRight()
        Orientation = (Orientation + 1) % 4
        nodeChecker.check()

        if wp_sys_enabled then
            pathfinder.add_waypoint("left")
        end
    end

    local function right(wp_sys_enabled)
        if wp_sys_enabled == nil or wp_sys_enabled == true then
            wp_sys_enabled = true
        end
        turtle.turnRight()
        Orientation = (Orientation + 1) % 4
        nodeChecker.check()

        turtle.dig()
        self.move()

        turtle.turnLeft()
        Orientation = (Orientation - 1) % 4
        nodeChecker.check()

        if wp_sys_enabled then
            pathfinder.add_waypoint("right")
        end
    end

    local function return_Base()
        local x, y, z = gps.locate()
        local waypoint_list = pathfinder.get_waypoint_list()
        if waypoint_list[1] == nil then
            logger.log("error", "No waypoints found")
            return false
        end

        for i = #waypoint_list, 1, -1 do
            local waypoint = waypoint_list[i]
            while true do
                local x, y, z = gps.locate()
                print(string.format("going to Waypoint - X: %d, Y: %d, Z: %d", waypoint.GPS.x, waypoint.GPS.y, waypoint.GPS.z))
                print("currently at - X: " .. x .. ", Y: " .. y .. ", Z: " .. z)
                if waypoint.GPS.x == x and waypoint.GPS.y == y and waypoint.GPS.z == z then
                    print("Arrived at waypoint")
                    break
                else
                    if waypoint.GPS.x < x then
                        if Orientation == 0 then
                            left(false)
                            x = x + 1
                        elseif Orientation == 1 then
                            back(false)
                            x = x + 1
                        elseif Orientation == 2 then
                            right(false)
                            x = x + 1
                        elseif Orientation == 3 then
                            forward(false)
                            x = x + 1
                        end
                    elseif waypoint.GPS.x > x then
                        if Orientation == 0 then
                            right(false)
                            x = x - 1
                        elseif Orientation == 1 then
                            forward(false)
                            x = x - 1
                        elseif Orientation == 2 then
                            left(false)
                            x = x - 1
                        elseif Orientation == 3 then
                            back(false)
                            x = x - 1
                        end
                    elseif waypoint.GPS.y < y then
                        up(false)
                        y = y + 1
                    elseif waypoint.GPS.y > y then
                        down(false)
                        y = y - 1
                    elseif waypoint.GPS.z < z then
                        if Orientation == 0 then
                            forward(false)
                            z = z + 1
                        elseif Orientation == 1 then
                            left(false)
                            z = z + 1
                        elseif Orientation == 2 then
                            back(false)
                            z = z + 1
                        elseif Orientation == 3 then
                            right(false)
                            z = z + 1
                        end
                    elseif waypoint.GPS.z > z then
                        if Orientation == 0 then
                            back(false)
                            z = z - 1
                        elseif Orientation == 1 then
                            right(false)
                            z = z - 1
                        elseif Orientation == 2 then
                            forward(false)
                            z = z - 1
                        elseif Orientation == 3 then
                            left(false)
                            z = z - 1
                        end
                    end
                end
                sleep(1)
            end
        end
    end

    function move()
        local success, reason = turtle.forward()
        if not success then
            logger.log("error", reason)

            -- If the reason he cant move is because it is obstructed, check the obstruction.
            -- If the obstruction is gravel or sand, dig it and try to move again.
            -- Loop this until the turtle can move again.
            while reason == "Movement obstructed" do
                local success, data = turtle.inspect()
                if success then
                    if data.name == "minecraft:gravel" or data.name == "minecraft:sand" then
                        turtle.dig()
                        success, reason = turtle.forward()
                        if success then
                            break
                        end
                    end
                end
            end
        end
        
        Travel_Distance = Travel_Distance - 1
        Session_Distance_Tracker = Session_Distance_Tracker + 1
        nodeChecker.check()
    end

    -- Public Methods
    self.down = down
    self.up = up
    self.forward = forward
    self.back = back
    self.left = left
    self.right = right

    self.return_Base = return_Base

    -- Private Methods
    self.move = move

    return self
end