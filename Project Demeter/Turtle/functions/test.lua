require "Progress"
require "Communication"

--local progress = Progress.new()

--progress.saveProgress("Iron", 100, {1, 2, 3}, "Mining", 1)
--print(progress.read_mission_file()["MineForResource"])

--peripheral.find("modem", rednet.open)

--rednet.broadcast("Hello, world!")

local communication = Communication.new()
communication.Setup_Demeter_Connection()