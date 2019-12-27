--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate.Jobs = Impersonate.Jobs or {}

function Impersonate.Jobs.PrintError(job, err)
  job = job or "Unkown"

  MsgC(Impersonate.UI.Color("_red"), "[Impersonate Jobs]: ", Color(255, 255, 255), "Error in validating job \"".. job.. "\". ",Impersonate.UI.Color("_red"), err.. "\n")
end

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Impersonate.Jobs:SetJob(ply, ID) // Need to add Whitelist
  if not IsValid(ply) or not ply:IsPlayer() then return end
  if not Impersonate.Jobs.JobTable[ID] then return end

  if hook.Call("Impersonate.Jobs.CanSwitchJob", Impersonate, ply, ID) == false then return end

  self:RemoveJobWeapons(ply)
  hook.Call("PlayerLoadout", GAMEMODE, ply, ID)
  ply:SetTeam(ID)
end

function Impersonate.Jobs:RemoveJobWeapons(ply)
  if not IsValid(ply) or not ply:IsPlayer() then return end

  for k, v in pairs(ply:GetWeapons()) do
    if v.Job then
      ply:StripWeapon(v:GetClass())
    end
  end
end
