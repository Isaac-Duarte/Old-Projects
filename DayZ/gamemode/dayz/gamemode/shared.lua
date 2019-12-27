--[[
	© 2019 DayZ, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
DayZ = DayZ or {}
DayZ.BaseDirectory = GM.FolderName .. "/gamemode/"
DayZ.Config = DayZ.Config or {}

GM.Name = "DayZ"
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
end
