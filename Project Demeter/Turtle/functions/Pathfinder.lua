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
            --funktioniert noch nicht ????? warum?????
            fs.delete("/Data/WayPoints.txt")
            waypoint_list = {}
        else
            for i = #waypoint_list, count, -1 do
                table.remove(waypoint_list, i)
                print("deleting waypoint " .. i)
            end
            write_waypoint_file()
        end
        --delete all waypoints after the first one       
    end

    local function add_waypoint(direction)
        --problem ist das der Waypoint beim ersten schritt erstellt wird und dann hier gecheckt wird nach dem block auf dem gestartet wurde
        --Evtl ein Dev problem das gelöst wird durch Base_Position mit speichern, hier muss wahrscheinlich ein anderer Test geschrieben werden
        check_waypoint_system()

        local x, y, z = gps.locate()
        if waypoint_list[2] == nil then
        --waypoint_list[2] wird gecheckt, da waypoint_list[1] immer die Base_Position ist
        --wenn waypoint_list[2] nil ist, dann hat die Turtle noch keinen Schritt gemacht
            local waypoint = {
                Direction = direction,
                GPS = {["x"]= x, ["y"] = y, ["z"] = z}
            }
            table.insert(waypoint_list, waypoint)
            write_waypoint_file()
        else
            if waypoint_list[1].GPS.x == x and waypoint_list[1].GPS.y == y and waypoint_list[1].GPS.z == z then
                --wenn die Turtle auf der Base Position ist, dann wird die Base Position gelöscht
                --und die Turtle kann sich wieder bewegen
                delete_all_following_waypoints(1)
            end
            for i = 1, #waypoint_list, 1 do
                if waypoint_list[i].GPS.x == x and waypoint_list[i].GPS.y == y and waypoint_list[i].GPS.z == z then
                    delete_all_following_waypoints(i)
                    break
                end
            end
            if waypoint_list[#waypoint_list].Direction ~= direction then
                local waypoint = {
                    Direction = direction,
                    GPS = {["x"]= x, ["y"] = y, ["z"] = z}
                }
                table.insert(waypoint_list, waypoint)
                write_waypoint_file()
            end
            --Fehlt hier ein Else? Um die Base position zu handeln
        end
    end

    local function get_waypoint_list()
        return waypoint_list
    end

    local function find_best_path(goal_x, goal_y, goal_z)
        --gibt die mindest anzahl an Waypoints zurück die benötigt werden um das ziel zu erreichen
        --wichtig ist hier das zuerst die höhe erreicht wird
        local target_waypoint_list = {}
        local x, y, z = gps.locate()

        local waypoint = {
            GPS = {["x"]= x, ["y"] = goal_y, ["z"] = z}
        }
        table.insert(target_waypoint_list, waypoint)
        
        waypoint = {
            GPS = {["x"]= goal_x, ["y"] = goal_y, ["z"] = z}
        }
        table.insert(target_waypoint_list, waypoint)

        waypoint = {
            GPS = {["x"]= goal_x, ["y"] = goal_y, ["z"] = goal_z}
        }
        table.insert(target_waypoint_list, waypoint)

        return target_waypoint_list
    end

    self.add_waypoint = add_waypoint
    self.get_waypoint_list = get_waypoint_list
    self.find_best_path = find_best_path

    
    return self
end