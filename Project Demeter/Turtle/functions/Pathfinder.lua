Pathfinder = {}
Pathfinder.new = function()
    local self = {}

    local waypoint_list = {}

    local function check_waypoint_file_exists()
        local file = io.open("/Data/WayPoints.txt", "r")
        if file then
            return true
        else
            return false
        end
    end

    local function setup_waypoint_file()
        if check_waypoint_file_exists() then
            return false
        else
            local file = io.open("/Data/WayPoints.txt", "w")
            if file then
                return true
            else
                return false
            end
        end
    end

    local function write_waypoint_file() --Hier wird die Mission in eine Datei geschrieben wichtig ist das eine Table als input genommen wird
        local file = io.open("/Data/WayPoints.txt", "w")
        if file then
            file:write(textutils.serialize(waypoint_list))
            file:close()
        end
    end
    
    --irgendwo muss noch bei einem neustart die waypoint_list geladen werden und die waypoint file gelesen

    local function add_waypoint(direction)
        --problem ist das der Waypoint beim ersten schritt erstellt wird und dann hier gecheckt wird nach dem block auf dem gestartet wurde
        --Evtl ein Dev problem das gelöst wird durch Base_Position mit speichern, hier muss wahrscheinlich ein anderer Test geschrieben werden
        setup_waypoint_file()
        local x, y, z = gps.locate()
        if waypoint_list[#waypoint_list] == nil then
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