--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate = Impersonate or {}
Impersonate.BaseDirectory = GM.FolderName .. "/gamemode/"
Impersonate.Config = Impersonate.Config or {}

GM.Name = "Impersonate"
GM.Author = "Fozie"
GM.Version = "0.01"

include("core/boot/sh_boot.lua")
AddCSLuaFile("core/boot/sh_boot.lua")

function GM:CanPlayerSuicide(pPlayer)
	pPlayer:ChatPrint("You can't suicide!")

	return true
end

function GM:OnReloaded()
  self:Initalize()
end

function GM:Initialize()
  Impersonate.Jobs:LoadJobs()
end
