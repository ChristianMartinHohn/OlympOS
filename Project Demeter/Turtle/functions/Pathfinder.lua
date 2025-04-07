Pathfinder = {}
Pathfinder.new = function()
    local self = {}

    local waypoint_list = {}

    local function check_waypoint_file_exists()
        local file = io.open("/Data/WayPoints.txt", "r")
        if file then
            file:close()
            return true
        else
            return false
        end
    end

    local function setup_waypoint_file()
        if check_waypoint_file_exists() then
            return true
        else
            local file = io.open("/Data/WayPoints.txt", "w")
            if file then
                file:write(Base_Position)
                file:close()
                return true
            else
                return false
            end
        end
    end

    local function write_waypoint_file()
        local file = io.open("/Data/WayPoints.txt", "w")
        if file then
            file:write(textutils.serialize(waypoint_list))
            file:close()
        end
    end

    local function check_waypoint_system()
        if waypoint_list[1] == nil then
        --wenn die waypoint_list leer ist, dann wurd die Turtle gerade erst gestartet
            if check_waypoint_file_exists() then
            --wenn eine waypoint file existiert, dann muss die turtle vor dem start sich schon mal bewegt haben
                local file = io.open("/Data/WayPoints.txt", "r")
                if file then
                    waypoint_list = textutils.unserialize(file:read("*a"))
                    file:close()
                end
            else
            --wenn die waypoint file nicht existiert, dann hat die turtle sich noch nicht bewegt und steht an der Base_Position
                if setup_waypoint_file() then
                    waypoint_list = {}
                    local file = io.open("/Data/WayPoints.txt", "r")
                    if file then
                        waypoint_list = textutils.unserialize(file:read("*a"))
                        file:close()
                    end
                end
            end
        --wenn die waypoint_list nicht leer ist, dann ist die Turtle mitten im Programm und es muss nichts gemacht werden
        end
    end

    local function add_waypoint(direction)
        --problem ist das der Waypoint beim ersten schritt erstellt wird und dann hier gecheckt wird nach dem block auf dem gestartet wurde
        --Evtl ein Dev problem das gelöst wird durch Base_Position mit speichern, hier muss wahrscheinlich ein anderer Test geschrieben werden
        check_waypoint_system()
        local x, y, z = gps.locate()
        if waypoint_list[2] == nil then
        --waypoint_list[2] wird gecheckt, da waypoint_list[1] immer die Base_Position ist
            local waypoint = {
                Direction = direction,
                GPS = {["x"]= x, ["y"] = y, ["z"] = z}
            }
            table.insert(waypoint_list, waypoint)
        else
            for i = 1, #waypoint_list, 1 do
                if waypoint_list[i].GPS.x == x and waypoint_list[i].GPS.y == y and waypoint_list[i].GPS.z == z then
                    print("Waypoint already exists")
                end
            end
            if waypoint_list[#waypoint_list].Direction ~= direction then
                local waypoint = {
                    Direction = direction,
                    GPS = {["x"]= x, ["y"] = y, ["z"] = z}
                }
                table.insert(waypoint_list, waypoint)
            end
        end
        write_waypoint_file()
    end


    self.add_waypoint = add_waypoint

    return self
end