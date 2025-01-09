Logger = {}
Logger.new = function ()
    local self = {}

    local function log(level, message)
        local color = colors.white
        if level == "info" then
            color = colors.green
        elseif level == "warning" then
            color = colors.yellow
        elseif level == "error" then
            color = colors.red
        end
        term.setTextColor(colors.white)
        write("[".. textutils.formatTime(os.time(), true) .. "] [")
        term.setTextColor(color)
        write(level:upper())
        term.setTextColor(colors.white)
        write("] ")
        write(message .. "\n")
    
        -- Write to file
        --local file = fs.open("log.txt", "a")
        --file.write("[" .. textutils.formatTime(os.time(), true) .. "] [" .. term.setTextColor(color) .. level:upper() .. term.setTextColor(color) .. "] " .. message)
    end

    self.log = log

    return self
end