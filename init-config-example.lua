-- MS Windows/Linux style command-arrow window moving
hs.loadSpoon("WindowCmdShifter")
spoon.WindowCmdShifter:bindHotkeys({
    up = {{"cmd"}, "up"},
    left = {{ "cmd"}, "left"},
    down = {{"cmd"}, "down"},
    right = {{"cmd"}, "right"},
    screenRight = {{"cmd", "alt"}, "right"},
    screenLeft = {{"cmd", "alt"}, "left"},
    -- screenUp = {{"cmd", "alt"}, "up"},
    -- screenDown = {{"cmd", "alt"}, "down"},
})