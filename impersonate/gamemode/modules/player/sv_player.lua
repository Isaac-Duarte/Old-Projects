--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate.Player = Impersonate.Player or {}

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Impersonate.Player:PlayerLoadout(ply, ID)
  if not IsValid(ply) or not ply:IsPlayer() then return end
  if not Impersonate.Jobs.JobTable[ID] then return end

  if Impersonate.Jobs.JobTable[ID].Loadout then
    for k, v in pairs(Impersonate.Jobs.JobTable[ID].Loadout) do
      local wep = ply:Give(v)

      if wep == NULL then return end

      wep.Job = true
    end
  end

  for k, v in pairs(Impersonate.Config.Loadout) do
    ply:Give(v)
  end
end

function Impersonate.Player:PlayerSpawn(ply)
  if not IsValid(ply) or not ply:IsPlayer() then return end

  self:PlayerLoadout(ply, Impersonate.Jobs:GetPlayerJobID(ply) or 1)
end

function Impersonate.Player:InitialSpawn(ply)
  Impersonate.Jobs:SetJob(ply, Impersonate.Config.DefaultJob)
end
