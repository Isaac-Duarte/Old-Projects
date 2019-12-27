AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/nicksmodels/asic_miner.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
	end

	self.socket = nil
end

function ENT:Touch(ent)
	if ent:GetClass() != "fbm_hub" and ent:GetClass() then return end

	ent:PlugIn(self)
end

function ENT:Use(ply)
	if self.socket == nil or self.socket:GetClass() != "fbm_hub" then return end

	if not ply:GetEyeTrace().Entity == self then return end

	self.socket:UnPlug(self)
end

function ENT:HasPower()
	if not self.socket then return false end
	if not self.socket.HasPower then return false end

	return true
end
