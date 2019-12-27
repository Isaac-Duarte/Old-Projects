--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate.Player = Impersonate.Player or {}

--[[---------------------------------------------------------
	Name: Meta Functions
-----------------------------------------------------------]]
local PLAYER = FindMetaTable("Player")

function PLAYER:Nick()
	return Impersonate.Net:GetSharedGameVar(self, "first_name").. " ".. Impersonate.Net:GetSharedGameVar(self, "last_name") or self:GetName()
end
