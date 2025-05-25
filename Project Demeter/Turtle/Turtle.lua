require "functions.Move"
require "functions.Fuel"
require "functions.Progress"
require "functions.Logger"
require "functions.InventoryManager"
require "functions.Communication"

local move = Move.new()
local logger = Logger.new()
local fuel = Fuel.new()
local progress = Progress.new()
local inventorymanager = InventoryManager.new()
local communication = Communication.new()

Development = true

ResourceNameList = {
    "minecraft:coal_ore",
    "minecraft:deepslate_coal_ore", 
    "minecraft:iron_ore",
    "minecraft:deepslate_iron_ore",
    "minecraft:copper_ore",
    "minecraft:deepslate_copper_ore",
    "minecraft:gold_ore",
    "minecraft:deepslate_gold_ore",
    "minecraft:redstone_ore", 
    "minecraft:deepslate_redstone_ore", 
    "minecraft:emerald_ore",
    "minecraft:deepslate_emerald_ore",
    "minecraft:lapis_ore",
    "minecraft:deepslate_lapis_ore",
    "minecraft:diamond_ore",
    "minecraft:deepslate_diamond_ore",
    "create_new_age:thorium_ore",
    "create_new_age:magnetite_block",
    "create:zinc_ore",
    "create:deepslate_zinc_ore",
}

HeightForResource = {
    ["minecraft:coal_ore"] = 95,
    ["minecraft:deepslate_coal_ore"] = 95,
    ["minecraft:iron_ore"] = 15,
    ["minecraft:deepslate_iron_ore"] = 15,
    ["minecraft:copper_ore"] = 48,
    ["minecraft:deepslate_copper_ore"] = 48,
    ["minecraft:gold_ore"] = -16,
    ["minecraft:deepslate_gold_ore"] = -16,
    ["minecraft:redstone_ore"] = -59,
    ["minecraft:deepslate_redstone_ore"] = -59,
    ["minecraft:emerald_ore"] = 236,
    ["minecraft:deepslate_emerald_ore"] = 236,
    ["minecraft:lapis_ore"] = -1,
    ["minecraft:deepslate_lapis_ore"] = -1,
    ["minecraft:diamond_ore"] = -59,
    ["minecraft:deepslate_diamond_ore"] = -59,
    ["create_new_age:thorium_ore"] = 25,
    ["create:zinc_ore"] = 48,
    ["create:deepslate_zinc_ore"] = 48,
}

--der shit hier oben muss nochmal richtig sortiert werden

Turtle_State = "IDLE" --IDLE, MOVING, MINING, RETURNING, REFUELING, EMERGENCY
Travel_Distance = 0
Base_Position = {["x"]= 0, ["y"] = 0, ["z"] = 0}

Pickaxe_Equipped = false
Offline_Mode = false
GPS_Enabled = false

DemeterID = 0

--Orientation muss entweder jedes mal herausgefunden werden oder mit gespeichert werden
Orientation = 0 -- 0 = NORTH, 1 = EAST, 2 = SOUTH, 3 = WEST
Debug = true
Fuel_Tab_ID = 0
UseResourcestoRefuel = false --Entweder remote setzten oder beim boot abfragen ob gefundene Kohle als Fuel genutzt werden soll
Session_Distance_Tracker = 0
--Bin noch am überlegen ob ich einbauen soll das kohle direkt zu kohle blöcken gecraftet wird aber dafür muss genug platz im inventar sein...


-- Wird das ganze hier noch gebraucht???
function IsResource(value) --Hier wird gecheckt ob der als Variable übergebene Wert eine Resource ist
    for i = 1,#ResourceNameList do
      if (ResourceNameList[i] == value) then
        return true
      end
    end
    return false
end

local function resourceValid(string)
    for _, resource in ipairs(ResourceNameList) do
        if string.find(resource, string) then
            return resource
        end
        
    end
    return false
end

local function stripmine()
    progress.update_Turtle_State("MINING")
    logger.log("info", "Starting strip mining")
    os.setComputerLabel("Stripmining for " .. MineForResource)

    while true do
        -- Check if the turtle has enough fuel
        if Travel_Distance < 25 then
            logger.log("warning", "Low fuel. Returning to base")
            returnToBase() -- muss noch geschrieben werden
        end

        -- Check if the turtle has enough space
        -- Würd ich nochmal überarbeiten
        if turtle.getItemCount(16) > 0 then
            logger.log("warning", "Inventory is full. Returning to base")
            returnToBase()
        end

        move.forward()
        move.forward()

        for i = 1, 5 do
            move.left()
        end

        for i = 1, 10 do
            move.right()
        end

        for i = 1, 5 do
            move.left()
        end

        --hier evtl checken ob neu Befehle gegeben wurden
    end
end

local function set_Orientation()
        -- Check the Orientation
        local x, y, z = gps.locate()
        move.forward(false)
        local x2, y2, z2 = gps.locate()
        
        -- 0 = NORTH, 1 = EAST, 2 = SOUTH, 3 = WEST
        if x2 > x then
            Orientation = 1
        elseif x2 < x then
            Orientation = 3
        elseif z2 > z then
            Orientation = 2
        elseif z2 < z then
            Orientation = 0
        end
    
        move.back(false)
end

local function check_left_Attachement()
    turtle.equipLeft()
    local item = turtle.getItemDetail()
    if not item then
        return false
    else
        local itemName = item.name
        if itemName == "minecraft:diamond_pickaxe" then
            Pickaxe_Equipped = true
        elseif itemName == "computercraft:wireless_modem_advanced" then
            Offline_Mode = false
        end
    end
    turtle.equipLeft()
end

local function check_right_Attachement()
    turtle.equipRight()
    local item = turtle.getItemDetail()
    if not item then
        return false
    else
        local itemName = item.name
        if itemName == "minecraft:diamond_pickaxe" then
            Pickaxe_Equipped = true
        elseif itemName == "computercraft:wireless_modem_advanced" then
            Offline_Mode = false
        end
    end
    turtle.equipRight()
end

local function check_turtle_functional()
    local emptySlots = inventorymanager.getEmptySlots()
    local dropped_item = false
    if not emptySlots then
        turtle.select(1)
        turtle.drop()
        dropped_item = true
    else
        turtle.select(emptySlots[1])
    end

    
    check_left_Attachement()
    check_right_Attachement()

    if dropped_item == true then
        move.forward()
        turtle.suck()
    end
    turtle.select(1)

    if not Pickaxe_Equipped then
        logger.log("error", "No pickaxe equipped.")
        communication.Send_Emergency("pickaxe_missing", fuel.getFuelPercent())
        Turtle_State = "EMERGENCY"
        -- hier bin ich mir noch nicht ganz sich ob ich die Turtle zurück zur Base schicken soll oder nicht (wahrscheinlich ja)
        return false
    else
        --check ATLAS / DEMETER connection
        logger.log("info", "Pickaxe is equipped.")
    end
    
    return true
end

local function setup()
    -- Wichtig das dass setup nur einmal aufgerufen wird, sonst wird die Turtle immer wieder zurückgesetzt
    progress.set_First_activation()

    local x, y, z = gps.locate()
    Base_Position = {["x"]= x, ["y"] = y, ["z"] = z}
    --hier ist evtl ein fehler drin weil gps.locate nicht so funktioniert
    fuel.first_refuel()
    local fuelLevel = turtle.getFuelLevel()


    Travel_Distance = fuelLevel / 2
    -- Define the resource to mine
    term.clear()
    

    
    --hier evtl 
    while true do
        write("What resource should the turtle mine? \n")
        write("> ")
        local mineForResource_input = read()
        --Muss MineForResource eine globale Variable sein oder kann ich die hier lokal definieren?
        MineForResource = resourceValid(mineForResource_input)

        -- Check if the resource is in the list
        if MineForResource ~= false then
            term.clear()
            logger.log("info", "Start mining for " .. MineForResource)
            break
        else
            term.clear()
            logger.log("warning", "Invalid resource. Please try again.")
        end
    end

    -- muss überarbeitet werden
    progress.saveProgress_local(MineForResource, Travel_Distance, Base_Position, Turtle_State)

    set_Orientation()

    logger.log("info", "Orientation is " .. Orientation)

    -- After the resource is defined, the turtle should move to the correct height
    progress.update_Turtle_State("MOVING")
    local goalHeight = HeightForResource[MineForResource]
    logger.log("info", "Moving to height " .. goalHeight)

    local x, y, z = gps.locate()
    local downSteps = y - goalHeight

    if downSteps > 0 then
        for i = 1, downSteps do
            move.down()
        end
    elseif downSteps < 0 then
        for i = 1, math.abs(downSteps) do
            move.up()
        end
    end
    logger.log("info", "Arrived at height " .. goalHeight)


    -- Start strip mining
    stripmine()
end

if not check_turtle_functional() then
    --Hier wird gecheckt ob die Turtle noch funktioniert, wenn nicht wird sie in den Emergency state versetzt
    --und die Turtle wird zurück zur Base geschickt
    if not Offline_Mode then --Keine Pickaxe aber Modem
        logger.log("error", "Turtle is not functional. Sending emergency message to Demeter.")
        --Communication.sendEmergencyMessage("Turtle is not functional. Returning to base.")
    end
    logger.log("error", "Turtle is not functional.")
    exit()
else
    logger.log("info", "Turtle is functional.")
end


exit()
if Development then
    set_Orientation()
    local x, y, z = gps.locate()
    Base_Position = {["x"]= x, ["y"] = y, ["z"] = z}

    move.navigate_to_Target(875, 83, 1835)
    sleep(5)
    move.return_Base()

    exit()
end



--Hier wird gecheckt ob die Turtle gerade neu gestartet wurde oder ob die bereits am Minen war,
--müssen nur dafür sorgen das wenn die Turtle Base ist entweder die File gelöscht wird oder wir sonst wie fest stellen die soll von vorne anfangen

Fuel_Tab_ID = shell.openTab("Info_Screen.lua")

--öffnet ein neues Tab mit dem Fuel_Screen, dieser bleibt offen auf ewig das schließen muss manuell gemacht werden. Der Fuel screen aktualisiert sich alle 60 Sekunden
--Potentiell wollte ich noch einen Communication screen einbauen wo der Comm status angezeigt wird

Co_Pilot_ID = shell.openTab("Co-Pilot.lua")



--hier das previous_mission setzten muss noch überarbeitet werden
local previous_mission = progress.read_mission_file()
if previous_mission ~= false then
    logger.log("info", "Old Session detected! Resuming mission")
    MineForResource = previous_mission["MineForResource"]
    Travel_Distance = previous_mission["Travel_Distance"]
    Base_Position = previous_mission["Base_Position"]
    Turtle_State = previous_mission["Turtle_State"]
    if Turtle_State ~= nil then
        if Turtle_State == "MINING" then
            stripmine()
        elseif Turtle_State == "RETURNING" then
            --Return to base
            --Info an Demeter das die Turtle zurück kommt
            logger.log("info", "Returning to base")

        elseif Turtle_State == "REFUELING" then
            --Refuel
            --Info an Demeter das die Turtle sich auflädt
            logger.log("info", "Refueling")

        elseif Turtle_State == "EMERGENCY" then
            --Emergency
            --Info an Demeter das die Turtle in einem Notfall ist
            --Evtl auch noch eine Nachricht an den Spieler
            --Am besten wäre es wenn Demeter die nachricht einfach weiterleitet, die Turtle muss nur an Demter senden können
            logger.log("info", "Emergency")

        elseif Turtle_State == "MOVING" then
            --Moving
            --Info an Demeter das die Turtle sich bewegt
            --Herausfinden wo die Turtle hin wollte
            logger.log("info", "Moving")

        elseif Turtle_State == "IDLE" then
            --Idle
            --Info an Demeter das die Turtle bereit ist für einen Auftrag
            logger.log("info", "Idle")
            
        end
    else
        setup()
    end
else
    setup()
end
