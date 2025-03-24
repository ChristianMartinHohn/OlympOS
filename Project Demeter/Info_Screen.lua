require "functions.Fuel"

local fuel = Fuel.new()

while true do
    fuel.show_FuelScreen()
    sleep(60)
end

--hier noch mehr infos anbieten wie zum beispiel die aktuelle Position und die Mission data, hab da ein paar ideen für