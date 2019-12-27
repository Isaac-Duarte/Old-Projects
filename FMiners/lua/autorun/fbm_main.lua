--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
FBM = FBM or {}

if SERVER then
  util.AddNetworkString("FBM:UpdatePrice")
  util.AddNetworkString("FBM:OpenMenu")
  util.AddNetworkString("FBM:ChangePowerState")
  util.AddNetworkString("FBM:Sell")

  AddCSLuaFile("fbm_config.lua")
end

include("fbm_config.lua")

--[[---------------------------------------------------------
	Name: functions
-----------------------------------------------------------]]

function FBM.Load()
  local files, dir = file.Find("fbm/*", "LUA")
  for k, v in pairs(files) do

    if string.sub(v, 1, 2) == "sv" then

      if SERVER then
        include("fbm/".. v)
        print("[FBM]: Loaded in fbm/".. v)
      end

    end

    if string.sub(v, 1, 2) == "cl" then
      if CLIENT then
        include("fbm/".. v)
        print("[FBM]: Loaded in fbm/".. v)
      end

      if SERVER then AddCSLuaFile("fbm/".. v) end
    end

    if string.sub(v, 1, 2) == "sh" then
      include("fbm/".. v)
      if SERVER then AddCSLuaFile("fbm/".. v) end

      print("[FBM]: Loaded in fbm/".. v)
    end
  end
end

hook.Add("Initialize", "FBM:Load", FBM.Load)

FBM.Load()
