# WindowCmdShifter
Hammerspoon Spoon implementing Windows-style window movement using cmd + arrow key

## Installing

Copy the WindowCmdShifter.spoon directory to your ~/.hammerspoon/Spoons directory.

## Configuring

Simply load the Spoon and bind your key mappings from your Hammerspoon config. An example is provided in
init-config-example.lua:

```lua
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
```
