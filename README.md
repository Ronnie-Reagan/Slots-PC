# ============ Slots Dev Info ============

This file will be ignored when building the executable.
It is intended for developers that wish to learn more about the inner workings of the game before delving deeper into the codebase.

## Stage One:
    - I created the simple basis for the game using a monolithic script; set up reels and machine and such as pseudo objects with locally global state.
    - Reels randomly change at every update call, this is funny looking and basically makes blur
    - cost per play is hardcoded to 1 unit per spin.
    - payouts are hardcoded as payments - this is to be changed into a multiplier system
    - black and white with no UI, just the symbols on screen with win/lose text and wallet amount displayed.

## Stage Two: Modularization
    - The monolithic script was split into separate modules (machine.lua, reels.lua, display.lua, config.lua) to improve readability, maintainability, and scalability.
    - config.lua now holds constants like reel symbols, payouts, spin costs, and colors.
    - display.lua abstracts rendering, allowing for easier future enhancements such as animations, fonts, and layouts.
    - machine.lua contains the game logic: spin handling, auto-spin mode, win detection, and wallet updates.
    - This separation enables independent testing of modules and easier extension, such as adding new symbols or payout structures.

## Stage Three: Auto-Spin and Timed Reels
    - Introduced auto-spin mode, allowing spins to trigger automatically at configurable intervals.
    - Implemented reel timers to control animation updates per reel, instead of updating all symbols every frame.
    - This creates a visual “blur” during spinning without locking up the main game loop.
    - Added per-reel timers for staggered stopping, giving a more realistic slot machine feel.

## Stage Four: Staggered Reel Stops and Animation
    - Each reel now stops sequentially, with a configurable delay between reels.
    - Reel states (spinning and stopped) are tracked independently for finer control.
    - Final results are calculated after all reels have stopped to ensure fair randomness.
    - The architecture now supports future animations (ease-out, slow-down effects) and sound effects per reel.

## Stage Five: Safety and Robustness
    - Initialization routines (machine.init() and display.init()) prevent nil errors if update or spin is called before setup.
    - Assertions added to validate config.reels and display.reels.
    - All timing and delays now use consistent units (seconds) to prevent misbehavior across different framerates.
    - The wallet is protected from going negative, even in auto-spin mode.

## Stage Six: Next Goals
    - Ease-out reel animation: make reels decelerate before stopping for a realistic arcade feel.
    - Dynamic payouts: move from static payments to multiplier-based rewards depending on bet size or symbol rarity.
    - UI overlay: buttons, auto-spin toggle, and visual effects for wins.
    - Audio feedback: spinning sounds, reel stop sounds, jackpot fanfare.
    - Save/load wallet: allow persistent progress across sessions.
    - Theming support: different sets of symbols, backgrounds, or reel layouts.

