--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate._Core = Impersonate._Core or {}

include("sh_loader.lua")

if SERVER then
  AddCSLuaFile("sh_loader.lua")
end

Impersonate._Core.LoadConfigs()
hook.Run("Impersonate._Core.PostLoadedConfig")

Impersonate._Core.LoadLibaries()
hook.Run("Impersonate._Core.PostLibariesLoaded")

Impersonate._Core.LoadCore()
hook.Run("Impersonate._Core.PostCoreLoaded")

Impersonate._Core.LoadModules()
hook.Run("Impersonate._Core.PostModuleLoaded")

timer.Simple(0, function()
  hook.Run("Impersonate._Core.PostLoaded")
end)
