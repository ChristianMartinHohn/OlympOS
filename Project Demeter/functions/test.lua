require "Progress"

local progress = Progress.new()

--progress.saveProgress("Iron", 100, {1, 2, 3}, "Mining", 1)
print(progress.read_mission_file()["MineForResource"])