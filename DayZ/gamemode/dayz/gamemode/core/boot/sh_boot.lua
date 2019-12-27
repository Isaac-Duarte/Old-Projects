--[[
	© 2019 DayZ, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
DayZ._Core = DayZ._Core or {}

include("sh_loader.lua")

if SERVER then
  AddCSLuaFile("sh_loader.lua")
end

DayZ._Core.LoadConfigs()
hook.Run("DayZ._Core.PostLoadedConfig")

DayZ._Core.LoadLibaries()
hook.Run("DayZ._Core.PostLibariesLoaded")

DayZ._Core.LoadCore()
hook.Run("DayZ._Core.PostCoreLoaded")

DayZ._Core.LoadModules()
hook.Run("DayZ._Core.PostModuleLoaded")

timer.Simple(0, function()
  hook.Run("DayZ._Core.PostLoaded")
end)
