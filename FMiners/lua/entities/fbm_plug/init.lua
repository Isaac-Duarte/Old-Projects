AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/livinrp/plug_main.mdl")
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
	if ent:GetClass() != "fbm_socket" and ent:GetClass() != "fbm_extention" then return end

	ent:PlugIn(self)
end

function ENT:Use(ply)
	if self.socket == nil or self.socket:GetClass() != "fbm_socket" and self.socket:GetClass() != "fbm_extention" then return end

	if not ply:GetEyeTrace().Entity == self then return end
	
	self.socket:UnPlug(self)
end

function ENT:HasPower()
	if self.socket == nil then return false end
	if not self.socket.HasPower then return false end

	return true
end
