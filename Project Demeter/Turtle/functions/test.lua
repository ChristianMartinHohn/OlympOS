local x, y, z = gps.locate()

local waypoint = {
    Direction = "forward",
    GPS = {["x"]= x, ["y"] = y, ["z"] = z}
}



print(x, y, z)
print(waypoint.GPS.x)