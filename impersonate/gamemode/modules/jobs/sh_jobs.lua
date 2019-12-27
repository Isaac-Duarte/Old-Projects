--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate.Jobs = {}
Impersonate.Jobs.JobTable = {}

function Impersonate.Jobs.PrintError(job, err)
  job = job or "Unkown"

  MsgC(Impersonate.UI.Color("_red"), "[Impersonate Jobs]: ", Color(255, 255, 255), "Error in validating job \"".. job.. "\". ",Impersonate.UI.Color("_red"), err.. "\n")
end

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Impersonate.Jobs:ValidateJob(jobTable)
  if not jobTable.ID then
    self.PrintError(jobTable.Name, "Job doesn't contain a valid ID.")
    return false
  end

  if not jobTable.Enum then
    self.PrintError(jobTable.Name, "Job doesn't have a valid Enum.")
    return false
  end

  if not jobTable.Name then
    self.PrintError(jobTable.Name, "Job doesn't have a valid Name.")
    return false
  end

  for k, v in pairs(self.JobTable) do
    if v.ID == jobTable.ID then
      self.PrintError(jobTable.Name, "Job doesn't have a unique ID.")
      return false
    end

    if v.Enum == jobTable.Enum then
      self.PrintError(jobTable.Name, "Job doesn't have a unique Enum.")
      return false
    end
  end

  return true
end

function Impersonate.Jobs:LoadJobs()
  local files, dirs = file.Find(Impersonate.BaseDirectory.. "modules/jobs/jobs/*", "LUA")

  for k, v in pairs(files) do
    include(Impersonate.BaseDirectory.. "modules/jobs/jobs/".. v)
    AddCSLuaFile(Impersonate.BaseDirectory.. "modules/jobs/jobs/".. v)
  end
end

function Impersonate.Jobs:RegisterJob(jobTable)
    if not jobTable then return false end
    if not self:ValidateJob(jobTable) then return false end

    team.SetUp(jobTable.ID, jobTable.Name, jobTable.Color or Color(255, 255, 255))

    self.JobTable[jobTable.ID] = jobTable
    _G[jobTable.Enum] = jobTable.ID

    Impersonate.DebugPrint("Jobs", "Added ".. jobTable.Name.. " (".. jobTable.ID.. ")")
end

function Impersonate.Jobs:GetJobs()
	return self.JobTable
end

function Impersonate.Jobs:GetJobByID(ID)
	return self.JobTable[ID] or false
end

function Impersonate.Jobs:GetPlayerJob(ply)
	if not IsValid(ply) or not ply.Team then return false end

	return self.JobTable[ply:Team()]
end

function Impersonate.Jobs:GetPlayerJobID(ply)
	return ply:Team()
end

function Impersonate.Jobs:PlayerHasJob(ply)
	return self:GetPlayerJob(ply) and true or false
end

function Impersonate.Jobs:PlayerIsJob(ply, ID)
	return ply:Team() == ID
end

function Impersonate.Jobs:GetNumPlayers(ID)
	local count = 0

	for k, v in pairs(player.GetAll()) do
		if self:GetPlayerJobID(v) == ID then
			count = count + 1
		end
	end

	return count
end
