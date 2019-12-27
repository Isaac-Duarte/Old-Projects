AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function GM:OnReloaded()
  if not Impersonate.Config.AUTO_REFRESH then return end

  self:Initalize()
end

function GM:Initalize()
  Impersonate.SQL:Initalize()
  Impersonate.Jobs:LoadJobs()
end

function GM:PlayerSpawn(pPlayer)
  Impersonate.Player:PlayerSpawn(pPlayer)
end

function GM:PlayerInitialSpawn(pPlayer)
  Impersonate.SQL:InitialSpawn(pPlayer)
end

function GM:PlayerLoadout(pPlayer, ID)
  Impersonate.Player:PlayerLoadout(pPlayer, ID)
end

function GM:PlayerDisconnected(pPlayer)
  Impersonate.SQL:PlayerDisconnected(pPlayer)
end
