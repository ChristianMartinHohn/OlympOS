local file = io.open("/Data/balls.txt", "w")
if file then
    file:write("sus")
    file:close()
end

fs.delete("/Data/WayPoints.txt")