--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate.Player = Impersonate.Player or {}

function GM:PlayerSpawn(pPlayer)
	pPlayer:SetModel("models/player/mossman.mdl")
end

function GM:PlayerInitialSpawn(pPlayer)
	pPlayer._char = {}
end

function Impersonate.Player.SelectedCharacter(pPlayer, tChar)
	pPlayer._char = tChar

	Impersonate.Net:UpdateSharedGameVar(pPlayer, "first_name", tChar.first_name)
	Impersonate.Net:UpdateSharedGameVar(pPlayer, "last_name", tChar.last_name)
	Impersonate.Net:UpdateSharedGameVar(pPlayer, "sex", tChar.sex)

	Impersonate.Net:UpdateGameVar(pPlayer, "money", tChar.money)
	Impersonate.Net:UpdateGameVar(pPlayer, "money_bank", tChar.money_bank)
	Impersonate.Net:UpdateGameVar(pPlayer, "vehicles", tChar.vehicles)
end hook.Add("Impersonate.SQL.SelectedCharacter", "Impersonate.Player.SelectedCharacter", Impersonate.Player.SelectedCharacter)

--[[---------------------------------------------------------
	Name: Meta Functions
-----------------------------------------------------------]]
local PLAYER = FindMetaTable("Player")

function PLAYER:Nick()
	return self._char.first_name.. " ".. self._char.last_name or self:GetName()
end
