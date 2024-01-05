local obj={}
obj.__index = obj

-- Metadata
obj.name = "WindowCmdShifter"
obj.version = "1.2"
obj.author = "Brent Atkinson <brent.atkinson@brent.atkinson@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"

local Positions = {
    FULL = "FULL",
    TOP = "TOP",
    LEFT = "LEFT",
    BOTTOM = "BOTTOM",
    RIGHT = "RIGHT",
    TOPLEFT = "TOPLEFT",
    BOTTOMLEFT = "BOTTOMLEFT",
    BOTTOMRIGHT = "BOTTOMRIGHT",
    TOPRIGHT = "TOPRIGHT"
}

local Directions = {
    UP = "UP",
    LEFT = "LEFT",
    DOWN = "DOWN",
    RIGHT = "RIGHT"
}

local Transitions = {
    FULL = {
        UP = Positions.TOP,
        LEFT = Positions.LEFT,
        DOWN = Positions.BOTTOM,
        RIGHT = Positions.RIGHT
    },
    TOP = {
        UP = Positions.FULL,
        LEFT = Positions.TOPLEFT,
        DOWN = Positions.BOTTOM,
        RIGHT = Positions.TOPRIGHT
    },
    LEFT = {
        UP = Positions.TOPLEFT,
        LEFT = Positions.FULL,
        DOWN = Positions.BOTTOMLEFT,
        RIGHT = Positions.RIGHT
    },
    BOTTOM = {
        UP = Positions.TOP,
        LEFT = Positions.BOTTOMLEFT,
        DOWN = Positions.FULL,
        RIGHT = Positions.BOTTOMRIGHT
    },
    RIGHT = {
        UP = Positions.TOPRIGHT,
        LEFT = Positions.LEFT,
        DOWN = Positions.BOTTOMRIGHT,
        RIGHT = Positions.FULL
    },
    TOPLEFT = {
        UP = Positions.TOP,
        LEFT = Positions.LEFT,
        DOWN = Positions.BOTTOMLEFT,
        RIGHT = Positions.TOPRIGHT
    },
    BOTTOMLEFT = {
        UP = Positions.TOPLEFT,
        LEFT = Positions.LEFT,
        DOWN = Positions.BOTTOM,
        RIGHT = Positions.BOTTOMRIGHT
    },
    BOTTOMRIGHT = {
        UP = Positions.TOPRIGHT,
        LEFT = Positions.BOTTOMLEFT,
        DOWN = Positions.BOTTOM,
        RIGHT = Positions.RIGHT
    },
    TOPRIGHT = {
        UP = Positions.TOP,
        LEFT = Positions.TOPLEFT,
        DOWN = Positions.BOTTOMRIGHT,
        RIGHT = Positions.RIGHT
    }
}

local function screenPositions(screen)
    local f = screen:frame()
    return {
        FULL = { x = f.x, y = f.y, w = f.w, h = f.h },
        TOP = { x = f.x, y = f.y, w = f.w, h = math.floor(f.h/2) },
        LEFT = { x = f.x, y = f.y, w = math.floor(f.w/2), h = f.h },
        BOTTOM = { x = f.x, y = f.y+math.floor(f.h/2), w = f.w, h = math.floor(f.h/2) },
        RIGHT = { x = f.x + math.floor(f.w/2), y = f.y, w = math.floor(f.w/2), h = f.h },
        TOPLEFT = { x = f.x, y = f.y, w = math.floor(f.w/2), h = math.floor(f.h/2) },
        BOTTOMLEFT = { x = f.x, y = f.y+math.floor(f.h/2), w = math.floor(f.w/2), h = math.floor(f.h/2) },
        BOTTOMRIGHT = { x = f.x+math.floor(f.w/2), y = f.y+math.floor(f.h/2), w = math.floor(f.w/2), h = math.floor(f.h/2) },
        TOPRIGHT = { x = f.x+math.floor(f.w/2), y = f.y, w = math.floor(f.w/2), h = math.floor(f.h/2) }
    }
end

local function windowPosition(window, positions)
    local f = window:frame()
    local dimSlush = 25
    for pos, g in pairs(positions) do
        if f.x == g.x and f.y == g.y and math.abs(f.w - g.w) <= dimSlush and math.abs(f.h - g.h) <= dimSlush  then
            return pos
        end
    end
    return nil
end

local function nextFrame(window, direction)
    local available = screenPositions(window:screen())
    local pos = windowPosition(window, available)
    local transitions = Transitions[pos or "FULL"]
    local nextPos = transitions[direction]
    return available[nextPos]
end

local function setWindowPosition(window, pos) 
    local f = window:frame()
    if f then
        f.x = pos.x
        f.y = pos.y
        f.w = pos.w
        f.h = pos.h
        window:setFrame(f)
    end
end

local function getWindowPosition(window)
    local currentScreen = window:screen()
    local available = screenPositions(currentScreen)
    return windowPosition(window, available)
end

local function moveWindow(window, direction)
    setWindowPosition(window, nextFrame(window, direction))
end

local function moveFocusedWindow(direction)
    moveWindow(hs.window.focusedWindow(), direction)
end

local function shiftUp()
    moveFocusedWindow(Directions.UP)
end

local function shiftLeft() 
    moveFocusedWindow(Directions.LEFT)
end

local function shiftDown()
    moveFocusedWindow(Directions.DOWN)
end

local function shiftRight() 
    moveFocusedWindow(Directions.RIGHT)
end

local function screenForDirection(screen, direction)
    if direction == Directions.UP then
        return screen:toNorth()
    elseif direction == Directions.LEFT then
        return screen:toWest()
    elseif direction == Directions.DOWN then
        return screen:toSouth()
    elseif direction == Directions.RIGHT then
        return screen:toEast()
    end
end

local function unanchoredScreenMove(window, direction)
    if direction == Directions.UP then
        return window:moveOneScreenNorth()
    elseif direction == Directions.LEFT then
        return window:moveOneScreenWest()
    elseif direction == Directions.DOWN then
        return window:moveOneScreenSouth()
    elseif direction == Directions.RIGHT then
        return window:moveOneScreenEast()
    end
end

local function anchoredScreenMove(window, position, direction)
    local currentScreen = window:screen()
    local nextScreen = screenForDirection(currentScreen, direction)
    local availableOnNext = screenPositions(nextScreen)
    local nextFrame = availableOnNext[position]
    setWindowPosition(window, nextFrame)
end

local function moveScreen(direction)
   local window = hs.window.focusedWindow()
   local currentPos = getWindowPosition(window)
   if currentPos then
      anchoredScreenMove(window, currentPos, direction)
   else
      unanchoredScreenMove(window, direction)
   end
end

local function screenRight()
   moveScreen(Directions.RIGHT)
end

local function screenLeft()
   moveScreen(Directions.LEFT)
end

local function screenUp()
   moveScreen(Directions.UP)
end

local function screenDown()
   moveScreen(Directions.DOWN)
end

local Binds = {
   up = shiftUp,
   left = shiftLeft,
   down = shiftDown,
   right = shiftRight,
   screenRight = screenRight,
   screenLeft = screenLeft,
   screenUp = screenUp,
   screenDown = screenDown
}

--- WindowCmdShifter:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for WindowCmdShifter
---
--- Parameters:
---  * mapping - A table containing hotkey objifier/key details for the following items:
---   * up - shifts the focused window up
---   * left - shifts the focused window left
---   * down - shifts the focused window down
---   * right - shifts the focused window right
function obj:bindHotkeys(mapping)
   for key, fn in pairs(Binds) do
      if mapping[key] then
         hs.hotkey.bindSpec(mapping[key], Binds[key])
      end
   end
end

return obj
