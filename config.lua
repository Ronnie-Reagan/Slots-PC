local config = {}

-- Self explanatory; these are the reel/key/symbol pairings
config.reels = {
    { "X", "O", "$" },
    { "X", "O", "$" },
    { "X", "O", "$" }
}

-- multiplier payout system; these are multipliers for ( payout = spinCost * payouts[winningSymbol] )
config.payouts = {
    X = 10,
    O = 5,
    ["$"] = 100
}

-- Default cost per spin
config.spinCost = 1

-- Default time between reel-flips/change when spinning
-- Does not affect the machine clock
config.spinDuration = 1 -- seconds

-- Default colours for drawing the reels / symbols to screen
config.colors = {
    X = {1, 0, 0},
    O = {0, 0, 1},
    ["$"] = {1, 1, 0},
    default = {1, 1, 1}
}

return config
