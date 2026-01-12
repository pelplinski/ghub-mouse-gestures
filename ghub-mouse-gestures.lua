--============================================================
--  Mouse Gestures Script for Logitech G HUB
--
--  Author: Piotr Pelpliński
--  Date:   11.01.2026
--
--  Repository:
--    https://github.com/pelplinski/ghub-mouse-gestures
--
--  Description:
--    This script enables mouse gestures similar to those available in Logitech Options+.
-- 
--    For each enabled gesture button, the script executes a macro based on the detected
--    gesture direction (up/down/left/right) or a click (press + release without enough movement).
-- 
--    It is recommended to assign the "Disabled" action or a temporary DPI Shift
--    in Logitech G HUB to the mouse button used for gestures, so the button
--    does not trigger its default function while the gesture is being performed.
--
--  Documentation:
--    https://github.com/pelplinski/ghub-mouse-gestures/blob/main/README.md
--============================================================

-- Enables or disables debug logging.
-- To find the button number for a mouse button you want to use for gestures,
-- enable this option, press the button, and check the console output.
enableDebug = false

-- Minimum horizontal/vertical mouse movement required to recognize a gesture
minDiff = 100

-- Maximum allowed gesture duration (in milliseconds) before timing out
maxTime = 600

-- Enable or disable gesture handling for the primary mouse button 
-- By default, button 1 is disabled for performance reasons.
EnablePrimaryMouseButtonEvents(false)

-- Name of the macro that is pressed when a gesture starts (mouse button press)
-- and released when the gesture ends (mouse button release).
-- This can be used to implement a DPI Shift via a macro instead of assigning
-- DPI Shift directly to the button in the device settings.
gestureHoldMacro = "GESTURE DPI SHIFT"

-- Gesture action definitions per mouse button
Gestures = {
-- Gesture definitions for mouse button 2 (Right mouse button on Logitech G502 X)
-- Enabled by default, to disable this block, add the opening --[[ at the beginning of this line
    [2] = {
        moveUp    = function() pressKeys("lctrl", "lshift", "t") end,            -- Reopen last closed tab
        moveDown  = function() pressKeys("lctrl", "r") end,                      -- Refresh current page
        moveLeft  = function() pressKeys("lctrl", "f4") end,                     -- Close current tab
        moveRight = function() pressKeys("lctrl", "t") end,                      -- Open new tab
        click     = function() PressAndReleaseMouseButton(3) end,                -- Right mouse click
        timeout   = function() PressAndReleaseMouseButton(3) end,                -- Right-click on gesture timeout
    },
-- ]]--
-- Gesture definitions for mouse button 4 (Back button / G4 on Logitech G502 X)
--[[ To enable, remove the opening [[ from this line to uncomment the block
    [4] = {
        moveUp    = function() PlayMacro("G4 HOLD + MOVE UP") end,               -- Play Macro "G4 HOLD + MOVE UP"
        moveDown  = function() PlayMacro("G4 HOLD + MOVE DOWN") end,             -- Play Macro "G4 HOLD + MOVE UP"
        moveLeft  = function() PlayMacro("G4 HOLD + MOVE LEFT") end,             -- Play Macro "G4 HOLD + MOVE UP"
        moveRight = function() PlayMacro("G4 HOLD + MOVE RIGHT") end,            -- Play Macro "G4 HOLD + MOVE UP"
        click     = function() PlayMacro("Back") end,                            -- Play Macro "Back"
        timeout   = function() OutputLogMessage("G4 Gesture Timeout\n") end,     -- No action on timeout
    },
-- ]]--
-- Gesture definitions for mouse button 5 (Sniper button on Logitech G502 X)
-- Enabled by default, to disable this block, add the opening --[[ at the beginning of this line
    [5] = {
        moveUp    = function() PlayMacro("SNIPER HOLD + MOVE UP") end,           -- Play Macro "SNIPER HOLD + MOVE UP"
        moveDown  = function() PlayMacro("SNIPER HOLD + MOVE DOWN") end,         -- Play Macro "SNIPER HOLD + MOVE DOWN"
        moveLeft  = function() PlayMacro("SNIPER HOLD + MOVE LEFT") end,         -- Play Macro "SNIPER HOLD + MOVE LEFT"
        moveRight = function() PlayMacro("SNIPER HOLD + MOVE RIGHT") end,        -- Play Macro "SNIPER HOLD + MOVE RIGHT"
        click     = function() PressAndReleaseMouseButton(2) end,                -- Middle mouse click
        timeout   = function() OutputLogMessage("Sniper Gesture Timeout\n") end, -- No action on timeout
    },
-- ]]--
-- Gesture definitions for mouse button 6 (Forward button / G5 on Logitech G502 X)
--[[ To enable, remove the opening [[ from this line to uncomment the block
    [6] = {
        moveUp    = function() PlayMacro("G5 HOLD + MOVE UP") end,              -- Play Macro "G5 HOLD + MOVE UP"
        moveDown  = function() PlayMacro("G5 HOLD + MOVE DOWN") end,            -- Play Macro "G5 HOLD + MOVE DOWN"
        moveLeft  = function() PlayMacro("G5 HOLD + MOVE LEFT") end,            -- Play Macro "G5 HOLD + MOVE LEFT"
        moveRight = function() PlayMacro("G5 HOLD + MOVE RIGHT") end,           -- Play Macro "G5 HOLD + MOVE RIGHT"
        click     = function() PlayMacro("Forward") end,                        -- Play Macro "Forward"
        timeout   = function() OutputLogMessage("G5 Gesture Timeout\n") end,    -- No action on timeout
    },
-- ]]--
-- Gesture definitions for mouse button 9 (G9 button on Logitech G502 X)
-- Example of window management for Windows 
-- Enabled by default, to disable this block, add the opening --[[ at the beginning of this line
    [9] = {
        moveUp    = function() pressKeys("lgui", "up") end,                    -- Maximize current window
        moveDown  = function() pressKeys("lgui", "down") end,                  -- Restore or minimize current window
        moveLeft  = function() pressKeys("lgui", "left") end,                  -- Snap window to the left side of the screen
        moveRight = function() pressKeys("lgui", "right") end,                 -- Snap window to the right side of the screen
        click     = function() pressKeys("lgui", "tab") end,                   -- Open Task View
        timeout   = function() OutputLogMessage("G9 Gesture Timeout\n") end,   -- No action
    },
-- ]]--

}

-- Gesture logic

function OnEvent(event, arg, family)

  if enableDebug then 
    OutputLogMessage("\nEvent type: " .. event .. ", Argument (Mouse button): " .. arg .. ", Family: " .. family .. "\n") 
  end

  if event == "MOUSE_BUTTON_PRESSED" and Gestures[arg] then

    PressMacro(gestureHoldMacro)

    Gestures[arg].tStart = GetRunningTime()
    Gestures[arg].xStart, Gestures[arg].yStart = GetMousePosition()

    if enableDebug then 
      OutputLogMessage("Gesture for button %d started.\n",arg)
    end
    
  end	
  
  if event == "MOUSE_BUTTON_RELEASED" and Gestures[arg] then
  
    ReleaseMacro(gestureHoldMacro)
    
    local gestureHandler
    tEnd = GetRunningTime();		
    xEnd, yEnd = GetMousePosition()
    
    -- Calculate differences
    tDiff = tEnd - Gestures[arg].tStart
    xDiff = xEnd - Gestures[arg].xStart
    yDiff = yEnd - Gestures[arg].yStart
    
    if enableDebug then 
        OutputLogMessage("Gesture for button %d ended.\n",arg)    
        OutputLogMessage("Gesture Time:\t\t%d (timout: %d)\n",tDiff,maxTime)
        OutputLogMessage("Posistion differnce:\tx: %d, y: %d (minimum: %d)\n",xDiff,yDiff, minDiff)
    end

    if tDiff >= maxTime then
       -- Gesture Timeout
       gestureHandler = Gestures[arg].timeout
    else
        if math.abs(xDiff) > math.abs(yDiff) then
          -- Horizontal Gesture
          primaryDiff     = xDiff
          positiveHandler = Gestures[arg].moveRight
          negativeHandler = Gestures[arg].moveLeft
        else
          -- Vertical Gesture
          primaryDiff     = yDiff
          positiveHandler = Gestures[arg].moveDown
          negativeHandler = Gestures[arg].moveUp
        end
        
        if primaryDiff > minDiff then 
          gestureHandler = positiveHandler
        elseif primaryDiff < -minDiff then 
          gestureHandler = negativeHandler
        else
          -- Click
          gestureHandler = Gestures[arg].click
        end
     end
    -- Execute the Gesture
    gestureHandler()
  end
end

function pressKeys(...)
    local args = {...}
    -- Delay between keypresses in miliseconds
    delay = 10
    
    for i = 1, #args do PressKey(args[i]); Sleep(delay) end
    for i = #args, 1, -1 do ReleaseKey(args[i]) end     	
end
