WayPoints = {}
WayPoints.new = function()
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
        setup_waypoint_file()
        local cur_gps_location = {gps.locate()}
        if waypoint_list[#waypoint_list] == nil then
            local waypoint = {
                Direction = direction,
                GPS = cur_gps_location
            }
            table.insert(waypoint_list, waypoint)
        else
            for i = 1, #waypoint_list do
                if waypoint_list[i].GPS == cur_gps_location then
                    for j = #waypoint_list, i, 1 do
                        table.remove(waypoint_list, j)
                        print("remove Waypoint " .. i .. " ")
                        --funktioniert noch nicht, glaube das es daran liegt das die GPS location geholt wird bevor der schritt gemacht wird
                    end
                    return
                end
            end

            if waypoint_list[#waypoint_list].Direction ~= direction then
                local waypoint = {
                    Direction = direction,
                    GPS = cur_gps_location
                }
                table.insert(waypoint_list, waypoint)
            end

            for i = 1, #waypoint_list do
                local waypoint = waypoint_list[i]
                print("Waypoint " .. i .. ": " .. waypoint.Direction .. " - GPS: " .. waypoint.GPS[1] .. ", " .. waypoint.GPS[2] .. ", " .. waypoint.GPS[3])
            end
        end

        
        write_waypoint_file()
    end


    self.add_waypoint = add_waypoint

    return self
end