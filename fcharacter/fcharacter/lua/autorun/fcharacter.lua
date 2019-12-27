--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
FCharacter = FCharacter or {}
FCharacter.Config = {}

FCharacter.Dir = "fcharacter"

AddCSLuaFile("fcharacter_config.lua")

include("fcharacter_config.lua")

if SERVER then
  include("fcharacter_mysql.lua")

  resource.AddWorkshop("1651806345") // https://steamcommunity.com/sharedfiles/filedetails/?id=1651806345
end

--[[---------------------------------------------------------
	Name: Main
-----------------------------------------------------------]]
function FCharacter.Load(dir)
  local files = file.Find(dir.. "/".. "*", "LUA")

  print("Loading ".. dir)

  for k, v in pairs(files) do
    if string.StartWith(v, "cl") then
      if CLIENT then
        local load = include(dir.. "/".. v)
        if load then load() end

        print(" -".. v)
      end

      AddCSLuaFile(dir.. "/".. v)
    end

    if string.StartWith(v, "sv") then
      if SERVER then
        local load = include(dir.. "/".. v)
        if load then load() end

        print(" -".. v)
      end
    end

    if string.StartWith(v, "sh") then
      local load = include(dir.. "/".. v)
      if load then load() end

      AddCSLuaFile(dir.. "/".. v)
      print(" -".. v)
    end
  end
end

function FCharacter.AddCSDir(dir)
  local files = file.Find(dir.. "/".. "*", "LUA")

  for k, v in pairs(files) do
    AddCSLuaFile(dir.. "/".. v)

    if CLIENT then
      include(dir.. "/".. v)
    end
  end
end

if GAMEMODE then
  FCharacter.Load(FCharacter.Dir.. "/libaries")
  FCharacter.Load(FCharacter.Dir)
  FCharacter.AddCSDir(FCharacter.Dir.. "/vgui")
else
  hook.Add("InitPostEntity", "FCharacter.Load", function()
    FCharacter.Load(FCharacter.Dir.. "/libaries")
    FCharacter.Load(FCharacter.Dir)
    FCharacter.AddCSDir(FCharacter.Dir.. "/vgui")

    hook.Remove("InitPostEntity", "FCharacter.Load")
  end)
end

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function FCharacter.PrintError(...)
  MsgC(Color(255, 120, 120), "[FCharacter]: ", Color(255, 255, 255), ..., "\n")
end

function FCharacter.Print(...)
  MsgC(Color(120, 255, 120), "[FCharacter]: ", Color(255, 255, 255), ..., "\n")
end
