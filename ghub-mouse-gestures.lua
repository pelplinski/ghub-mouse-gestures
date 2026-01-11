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
--[[ Gesture definitions for mouse button 2 (To enable, remove the opening [[ from this line to uncomment the block)
    [2] = {
        moveUp    = function() PlayMacro("G2 HOLD + MOVE UP") end,
        moveDown  = function() PlayMacro("G2 HOLD + MOVE DOWN") end,
        moveLeft  = function() PlayMacro("G2 HOLD + MOVE LEFT") end,
        moveRight = function() PlayMacro("G2 HOLD + MOVE RIGHT") end,
        click     = function() PlayMacro("G2 CLICK") end,
        timeout   = function() OutputLogMessage("G2 Gesture Timeout\n") end,
    },
-- ]]--
--[[ Gesture definitions for mouse button 3 (To enable, remove the opening [[ from this line to uncomment the block)
    [3] = {
        moveUp    = function() PlayMacro("G3 HOLD + MOVE UP") end,
        moveDown  = function() PlayMacro("G3 HOLD + MOVE DOWN") end,
        moveLeft  = function() PlayMacro("G3 HOLD + MOVE LEFT") end,
        moveRight = function() PlayMacro("G3 HOLD + MOVE RIGHT") end,
        click     = function() PlayMacro("G3 CLICK") end,
        timeout   = function() OutputLogMessage("G3 Gesture Timeout\n") end,
    },
-- ]]--
--[[ Gesture definitions for mouse button 4 (To enable, remove the opening [[ from this line to uncomment the block)
    [4] = {
        moveUp    = function() PlayMacro("G4 HOLD + MOVE UP") end,
        moveDown  = function() PlayMacro("G4 HOLD + MOVE DOWN") end,
        moveLeft  = function() PlayMacro("G4 HOLD + MOVE LEFT") end,
        moveRight = function() PlayMacro("G4 HOLD + MOVE RIGHT") end,
        click     = function() PlayMacro("G4 CLICK") end,
        timeout   = function() OutputLogMessage("G4 Gesture Timeout\n") end,
    },
-- ]]--
-- Gesture definitions for mouse button 5 (enabled by default)
    [5] = {
        moveUp    = function() PlayMacro("G5 HOLD + MOVE UP") end,
        moveDown  = function() PlayMacro("G5 HOLD + MOVE DOWN") end,
        moveLeft  = function() PlayMacro("G5 HOLD + MOVE LEFT") end,
        moveRight = function() PlayMacro("G5 HOLD + MOVE RIGHT") end,
        click     = function() PlayMacro("G5 CLICK") end,
        timeout   = function() OutputLogMessage("G5 Gesture Timeout\n") end,
    },
-- ]]--
--[[ Gesture definitions for mouse button 6 (To enable, remove the opening [[ from this line to uncomment the block)
    [4] = {
        moveUp    = function() PlayMacro("G6 HOLD + MOVE UP") end,
        moveDown  = function() PlayMacro("G6 HOLD + MOVE DOWN") end,
        moveLeft  = function() PlayMacro("G6 HOLD + MOVE LEFT") end,
        moveRight = function() PlayMacro("G6 HOLD + MOVE RIGHT") end,
        click     = function() PlayMacro("G6 CLICK") end,
        timeout   = function() OutputLogMessage("G6 Gesture Timeout\n") end,
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
       gestureHandler = Gesture[arg].timeout
    else
        if math.abs(xDiff) > math.abs(yDiff) then
          -- Horizontal Gesture
          primaryDiff     = xDiff
          positiveHandler = Gesture[arg].moveRight
          negativeHandler = Gesture[arg].moveLeft
        else
          -- Vertical Gesture
          primaryDiff     = yDiff
          positiveHandler = Gesture[arg].moveUp
          negativeHandler = Gesture[arg].moveDown
        end
        
        if primaryDiff > minDiff then 
          gestureHandler = positiveHandler
        elseif primaryDiff < -minDiff then 
          gestureHandler = negativeHandler
        else
          -- Click
          gestureHandler = Gesture[arg].click
        end
     end
    -- Execute the Gesture
    gestureHandler()
  end
end
