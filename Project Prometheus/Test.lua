local monitor = peripheral.find("monitor") or term
monitor.setBackgroundColour(colors.gray)
monitor.clear()
monitor.setTextScale(0.5)

-- Radar-Konfiguration
local radar_size = 37 -- Größe des Radars (muss ungerade sein)
local center = math.ceil(radar_size / 2) -- Zentrum des Radars
local objects = {
    {x = -3, y = -2}, -- Beispielobjekt 1
    {x = 2, y = 4},   -- Beispielobjekt 2
    {x = 0, y = 0},   -- Beispielobjekt im Zentrum
}

-- Funktion, um das Radar zu zeichnen
local function draw_radar()
    monitor.clear()
    for y = 1, radar_size do
        for x = 1, radar_size do
            monitor.setCursorPos(x, y)
            if x == center and y == center then
                -- Zentrum des Radars
                monitor.setBackgroundColor(colors.red)
                monitor.write(" ")
            else
                -- Prüfen, ob ein Objekt an dieser Position ist
                local is_object = false
                for _, obj in ipairs(objects) do
                    local obj_x = center + obj.x
                    local obj_y = center + obj.y
                    if obj_x == x and obj_y == y then
                        is_object = true
                        break
                    end
                end
                if is_object then
                    monitor.setBackgroundColor(colors.green)
                else
                    monitor.setBackgroundColor(colors.black)
                end
                monitor.write(" ")
            end
        end
    end
    monitor.setBackgroundColor(colors.black)
end

-- Radar zeichnen
draw_radar()