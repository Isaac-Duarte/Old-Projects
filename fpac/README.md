# FPac
Adds file packing in Lua.

All of the files are saved data/fpac/PACK_NAME.dat.

Feel free to modify to your own needs.

## Instalation
You can put this in an addon or lua/autorun/fpac.lua

### Example
```lua
local tbl = {
  {
    name = "test.lua",
    data = "Fuck Garry's Mod"
  },
  {
    name = "fozie.lua",
    data = "while true do end"
  }
}

FPac.GeneratePack("fuck_garry", tbl)
local succ, data = FPac.ReadFile("fuck_garry")

if succ then
  PrintTable(data)
end
```

## Video (Click on it)
[![youtube](https://img.youtube.com/vi/jsC9bHzIYs8/hqdefault.jpg)](https://www.youtube.com/watch?v=jsC9bHzIYs8)
