local display = require("display")
local machine = require("machine")

function love.load()
    -- initialization of systems with internal configurations or defaults
    display.init()
    machine.init()
end

function love.update(dt)
    machine.update(dt)
end

function love.draw()
    display.draw()
end

function love.keypressed(key)
    if key == "space" then
        machine.toggleAuto()
    elseif key == "return" then
        machine.spin()
    end
end
