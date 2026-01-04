# Steal a Brainrot Require Alternative

The only point of this is for SAB scripts to loadstring these instead of directly calling require() on the ones ingame because it makes your script detected.
Example:
lua```
local Synchronizer = loadstring(game:HttpGet("https://github.com/LuauExploiter/SAB-Requires/Synchronizer.lua"))()
local Rarities = loadstring(game:HttpGet("https://github.com/LuauExploiter/SAB-Requires/Rarities.lua"))()
local NumberUtils = loadstring(game:HttpGet("https://github.com/LuauExploiter/SAB-Requires/NumberUtils.lua"))()
local Animals = loadstring(game:HttpGet("https://github.com/LuauExploiter/SAB-Requires/Animals.lua"))()
local AnimalsShared = loadstring(game:HttpGet("https://github.com/LuauExploiter/SAB-Requires/AnimalsShared.lua"))()```

Then from there you could just use the functions/purpose it serves inside your script. 
