local config = require("config")

local display = {
    reels = {
        { current = "X" },
        { current = "X" },
        { current = "X" }
    },
    message = "",
    wallet = 1000,
    layout = {
        xStart = 150,
        yStart = 150,
        reelSpacing = 120,
        reelWidth = 100,
        reelHeight = 100,
        messageY = 300
    },
    fonts = {}
}

--- Initializes display fonts and any reusable graphics state
function display.init()
    display.fonts.default = love.graphics.newFont(24)
    display.fonts.message = love.graphics.newFont(20)
    display.fonts.small = love.graphics.newFont(14)
end

--- Draws a single reel symbol with proper alignment and color
---@param index integer reel index
---@param symbol string symbol to draw
function display.drawReel(index, symbol)
    local color = config.colors[symbol] or config.colors.default
    love.graphics.setColor(color)

    local x = display.layout.xStart + (index - 1) * display.layout.reelSpacing
    local y = display.layout.yStart

    love.graphics.setFont(display.fonts.default or love.graphics.newFont(24))
    love.graphics.rectangle("line", x - 10, y - 10, display.layout.reelWidth, display.layout.reelHeight, 8, 8)
    love.graphics.printf(symbol, x - 10, y + display.layout.reelHeight / 4, display.layout.reelWidth, "center")
end

--- Draws the entire slot machine display
function display.draw()
    -- Reels
    for i = 1, #display.reels do
        display.drawReel(i, display.reels[i].current)
    end

    -- Message
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(display.fonts.message or love.graphics.newFont(20))
    love.graphics.printf(display.message, 0, display.layout.messageY, love.graphics.getWidth(), "center")

    -- Wallet
    love.graphics.setFont(display.fonts.small or love.graphics.newFont(14))
    love.graphics.print("Wallet: $" .. display.wallet, 20, love.graphics.getHeight() - 40)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 20, love.graphics.getHeight() - 20)
end

return display
