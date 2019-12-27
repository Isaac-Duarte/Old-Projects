--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
local THEIF = {}

THEIF.ID = 2
THEIF.Enum = "JOB_THIEF"
THEIF.Name = "Thief"
THEIF.Color = Color(0, 0, 0)

THEIF.Loadout = {
  "weapon_crowbar",
}

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function THEIF.Spawn(ply)

end

Impersonate.Jobs:RegisterJob(THEIF)
