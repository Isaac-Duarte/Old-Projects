AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/livinrp/catminer_s9.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:SetMass(200)
	end

	self:SetHealth(250)

	self.plug = ents.Create("fbm_plug")

	self.plug:SetPos(self:LocalToWorld(Vector(-10, 0, 0)) + Vector(0, 0, 10))

	self.plug:Spawn()

	self.plug.rope = constraint.Rope(self, self.plug, 0, 0, Vector(0, 11, 1), Vector(0, 0, 3.7), 200, 0, 0, 1, "cable/cable2", false)

	self.soundid = 0

	self.time = CurTime()
end

function ENT:Think()
	if self.plug:HasPower() != self:GetHasPower() then
		self:SetHasPower(self.plug:HasPower())
	end

	if not self:GetHasPower() and self:GetIsActivated() then
		self:ChangeIsMining(false)
	end

	if self:GetIsActivated() then
		if CurTime() >= self.time + 1 then
			self.time = CurTime()

			local rate = FBM.CONFIG.Rate or 0
			local amount = self:GetBitcoin() or 0

			self:SetBitcoin(amount + rate)
		end
	end
end

function ENT:ChangeIsMining(state)
	if self:GetHasPower() == false and self:GetIsActivated() == false then return end

	self:SetIsActivated(state)

	if self:GetIsActivated() then
		self.soundid = self:StartLoopingSound("ambient/machines/air_conditioner_loop_1.wav")
	else
		self:StopLoopingSound(self.soundid or 0)
	end
end

function ENT:Use(ply)
	if not IsValid(ply) and not ply:IsPlayer() then return end

	net.Start("FBM:OpenMenu")
		net.WriteEntity(self)
	net.Send(ply)
end

function ENT:OnTakeDamage(damage)
	self:SetHealth(self:Health() - damage:GetDamage())
	if self:Health() <= 0 then
		self:Remove()
	end
end

function ENT:OnRemove()
	self:StopLoopingSound(self.soundid or 0)

	if not IsValid(self.plug) then return end
	self.plug:Remove()
end
