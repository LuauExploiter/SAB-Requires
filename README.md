# Steal a Brainrot Require Alternative

The only point of this is for Steal a Brainrot scripts to loadstring these instead of using require() on the ones ingame because it makes your script detected.
To use this, just do something like:
```lua
local Synchronizer = loadstring(game:HttpGet("https://raw.githubusercontent.com/LuauExploiter/SAB-Requires/main/Synchronizer.lua"))()
local Rarities = loadstring(game:HttpGet("https://raw.githubusercontent.com/LuauExploiter/SAB-Requires/main/Rarities.lua"))()
local NumberUtils = loadstring(game:HttpGet("https://raw.githubusercontent.com/LuauExploiter/SAB-Requires/main/NumberUtils.lua"))()
local Animals = loadstring(game:HttpGet("https://raw.githubusercontent.com/LuauExploiter/SAB-Requires/main/Animals.lua"))()
local AnimalsShared = loadstring(game:HttpGet("https://raw.githubusercontent.com/LuauExploiter/SAB-Requires/main/AnimalsShared.lua"))()
```

Then from there you could just use the functions/purpose it serves inside your script. 
