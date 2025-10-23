local config = require("config")
local reels = require("reels")
local display = require("display")

local machine = {
    spinning = false,
    auto = false,

    spinTimer = 0,
    reelTimer = 0,

    reelCount = 3,
    reelStates = {}, -- will hold per-reel info
    timePerReel = 0.1,   -- how often a reel changes symbol during spin
    stopDelay = 0.333,      -- delay between each reel stopping
    waitDelay = 1.0,      -- delay before next auto-spin
    waitTimer = 0.0
}

--- Initialize reel state
function machine.init()
    for i = 1, machine.reelCount do
        machine.reelStates[i] = {
            spinning = false,
            stopTime = (i - 1) * machine.stopDelay,
            stopped = false
        }
    end
end

--- Begin a new spin sequence
function machine.spin()
    if machine.spinning then return end

    if display.wallet < config.spinCost then
        display.message = "Out of funds!"
        return
    end

    display.wallet = display.wallet - config.spinCost
    display.message = "Spinning..."
    machine.spinning = true
    machine.spinTimer = 0
    machine.reelTimer = 0
    machine.waitTimer = 0

    for i = 1, machine.reelCount do
        machine.reelStates[i].spinning = true
        machine.reelStates[i].stopped = false
    end
end

--- Perform one update frame
function machine.update(dt)
    if machine.spinning then
        machine.spinTimer = machine.spinTimer + dt
        machine.reelTimer = machine.reelTimer + dt

        -- Animate all currently spinning reels
        if machine.reelTimer >= machine.timePerReel then
            for i = 1, machine.reelCount do
                if machine.reelStates[i].spinning then
                    local r = math.random(1, #config.reels[i])
                    display.reels[i].current = config.reels[i][r]
                end
            end
            machine.reelTimer = 0
        end

        -- Stop reels one-by-one
        for i = 1, machine.reelCount do
            local reel = machine.reelStates[i]
            if reel.spinning and machine.spinTimer >= reel.stopTime + config.spinDuration then
                reel.spinning = false
                reel.stopped = true

                local symbol = config.reels[i][math.random(1, #config.reels[i])]
                display.reels[i].current = symbol
            end
        end

        -- Check if all reels stopped
        local allStopped = true
        for i = 1, machine.reelCount do
            if not machine.reelStates[i].stopped then
                allStopped = false
                break
            end
        end

        if allStopped then
            machine.spinning = false
            machine.spinTimer = 0

            -- Final pick ensures fairness
            local one, two, three = reels.pick()
            display.reels[1].current, display.reels[2].current, display.reels[3].current = one, two, three

            local win, symbol = reels.checkWin(display)
            if win then
                display.message = "JACKPOT with " .. string.rep(symbol, 3) .. " !"
                display.wallet = display.wallet + (config.spinCost * config.payouts[symbol])
            else
                display.message = "No win, try again."
            end

            machine.waitTimer = machine.waitDelay
        end

    elseif machine.auto then
        -- Auto-spin countdown
        machine.waitTimer = machine.waitTimer - dt
        if machine.waitTimer <= 0 then
            machine.spin()
        end
    end
end

--- Toggle auto mode
function machine.toggleAuto()
    machine.auto = not machine.auto
    display.message = machine.auto and "Auto-spin enabled." or "Auto-spin disabled."
    if machine.auto then
        machine.waitTimer = 0
    end
end

return machine
