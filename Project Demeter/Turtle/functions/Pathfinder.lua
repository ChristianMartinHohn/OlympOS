Pathfinder = {}
Pathfinder.new = function()
    local self = {}

    local waypoint_list = {}

    local function check_waypoint_file_exists()
        return fs.exists("/Data/WayPoints.txt")
    end

    local function write_waypoint_file()
        local file = io.open("/Data/WayPoints.txt", "w")
        if file then
            file:write(textutils.serialize(waypoint_list))
            file:close()
        end
    end

    local function read_waypoint_file()
        local file = io.open("/Data/WayPoints.txt", "r")
        if file then
            local tmp_list = textutils.unserialize(file:read("*a"))
            file:close()
            return tmp_list
        end
    end

    local function create_waypoint_file()
        waypoint_list = {}
        local waypoint = {
            Direction = "Base_Position",
            GPS = {["x"]= Base_Position.x, ["y"] = Base_Position.y, ["z"] = Base_Position.z}
        }
        table.insert(waypoint_list, waypoint)
        write_waypoint_file()
    end

    local function check_waypoint_system()
        if waypoint_list[1] == nil then
            print("Waypoint list is empty")
        --wenn die waypoint_list leer ist, dann wurd die Turtle gerade erst gestartet
            if check_waypoint_file_exists() then
            --wenn eine waypoint file existiert, dann muss die turtle vor dem Programm start sich schon mal bewegt haben
                waypoint_list = read_waypoint_file()
            else
                create_waypoint_file()
                return true
            end
        end
    end

    local function delete_all_following_waypoints(count)
        if count == 1 then
            fs.delete("/Data/WayPoints.txt")
            return
        else
            for i = count, #waypoint_list, 1 do
                table.remove(waypoint_list, i)
                print("Deleted waypoint " .. i)
            end
        end
        --delete all waypoints after the first one       
    end

    local function add_waypoint(direction)
        --problem ist das der Waypoint beim ersten schritt erstellt wird und dann hier gecheckt wird nach dem block auf dem gestartet wurde
        --Evtl ein Dev problem das gelöst wird durch Base_Position mit speichern, hier muss wahrscheinlich ein anderer Test geschrieben werden
        check_waypoint_system()

        local x, y, z = gps.locate()
        print(#waypoint_list)
        if waypoint_list[2] == nil then
        --waypoint_list[2] wird gecheckt, da waypoint_list[1] immer die Base_Position ist
        --wenn waypoint_list[2] nil ist, dann hat die Turtle noch keinen Schritt gemacht
            local waypoint = {
                Direction = direction,
                GPS = {["x"]= x, ["y"] = y, ["z"] = z}
            }
            table.insert(waypoint_list, waypoint)
        else
            for i = 1, #waypoint_list, 1 do
                if waypoint_list[i].GPS.x == x and waypoint_list[i].GPS.y == y and waypoint_list[i].GPS.z == z then
                    delete_all_following_waypoints(i)
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
        write_waypoint_file() --muss wo anderes hin --dev
    end

    local function get_waypoint_list()
        return waypoint_list
    end

    self.add_waypoint = add_waypoint
    self.get_waypoint_list = get_waypoint_list

    
    return self
end