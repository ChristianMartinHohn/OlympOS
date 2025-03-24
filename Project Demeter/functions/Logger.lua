Logger = {}
Logger.new = function ()
    local self = {}

    -- Create logs directory if it doesn't exist
    if not fs.exists("logs") then
        fs.makeDir("logs")
    end

    -- Generate log file name based on current date
    local logFileName = "logs/" .. os.date("%Y-%m-%d") .. "-log.log"

    local function log(level, message)
        local color = colors.white
        if level == "info" then
            color = colors.green
        elseif level == "warning" then
            color = colors.yellow
        elseif level == "error" then
            color = colors.red
        elseif level == "debug" then
            color = colors.blue
        end
        term.setTextColor(colors.white)
        write("[".. textutils.formatTime(os.time(), true) .. "] [")
        term.setTextColor(color)
        write(level:upper())
        term.setTextColor(colors.white)
        write("] ")
        write(message .. "\n")
    
        -- Write to file
        local file = fs.open(logFileName, "a")
        file.write("[" .. textutils.formatTime(os.time(), true) .. "] [" .. level:upper() .. "] " .. message .. "\n")
        file.close()
    end

    local function debug(message)
        if Debug then
            self.log("debug", message)
        end
    end

    self.log = log
    self.debug = debug

    return self
end