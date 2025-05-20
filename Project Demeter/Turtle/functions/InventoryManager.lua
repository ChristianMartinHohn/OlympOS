InventoryManager = {}
InventoryManager.new = function ()
    local self = {}

    -- ist bis jz eine von co-pilot generierte liste also nicht wirklich gut duchdacht
    local itemValueList = {
        "minecraft:grass_block",
        "minecraft:dirt",
        "minecraft:stone",
        "minecraft:cobblestone",
        "minecraft:planks",
        "minecraft:oak_planks",
        "minecraft:spruce_planks",
        "minecraft:birch_planks",
        "minecraft:jungle_planks",
        "minecraft:acacia_planks",
        "minecraft:dark_oak_planks",
        "minecraft:crimson_planks",
        "minecraft:warped_planks"
    }

    local function getInventory()
        local inventory = {}
        for i = 1, 16 do
            local item = turtle.getItemDetail(i)
            if item then
                inventory[i] = {
                    name = item.name,
                    count = item.count
                }
            else
                inventory[i] = nil
            end
        end
        return inventory
    end

    local function getEmptySlots()
        local emptySlots = {}

        local inventory = getInventory()

        for i = 1, #inventory do
            if inventory[i] == nil then
                table.insert(emptySlots, i)
            end
        end
        if #emptySlots == 0 then
            return false
        end
        return emptySlots
    end

    self.getInventory = getInventory
    self.getEmptySlots = getEmptySlots

    return self
end