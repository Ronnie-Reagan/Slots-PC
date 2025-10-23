local config = require("config")

local reels = {}

math.randomseed(os.time()) -- simple randomization
math.random() -- throwaway to "get into the random nummber system"
math.random()
math.random()

function reels.pick()
    -- randomly pick reels to stop on
    local one, two, three = math.random(1, 3), math.random(1, 3), math.random(1, 3)
    return config.reels[1][one], config.reels[2][two], config.reels[3][three]
end

function reels.randomize(display)
    -- randomly select reels to display while spinning
    for i = 1, 3 do
        local r = math.random(1, #config.reels[i])
        display.reels[i].current = config.reels[i][r]
    end
end

function reels.checkWin(display)
    -- check for a win and return true/false [symbol] so the symbol can be used at payout calculation
    local a, b, c = display.reels[1].current, display.reels[2].current, display.reels[3].current
    if a == b and b == c then
        return true, a
    else
        return false
    end
end

return reels
