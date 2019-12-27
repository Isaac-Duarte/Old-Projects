AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function GM:OnReloaded()
  if not DayZ.Config.AUTO_REFRESH then return end

  self:Initalize()
end

function GM:Initalize()
end
