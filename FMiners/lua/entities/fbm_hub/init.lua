AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/bitminer/usb_hub.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS )
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:SetMass(200)
	end

	self:SetHealth(250)

	self.HasPower = false

	self.plug = ents.Create("fbm_plug")

	self.plug:SetPos(self:LocalToWorld(Vector(-10, 0, 0)) + Vector(0, 0, 10))
	self.plug.parent = self

	self.plug:Spawn()

	self.plug.rope = constraint.Rope(self, self.plug, 0, 0, Vector(-9, 0, 2), Vector(0, 0, 3.7), 200, 10, 0, 1, "cable/cable2", false)

	self.soundid = 0

	self.time = CurTime()

	self.plugs = {}

	self.sockets = {
		{ -- Row 1
			pos = Vector(6.5, -3.2, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(6.5, -3.2 + (1.5 * 2) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(6.5, -3.2 + (1.5 * 3) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(6.5, -3.2 + (1.5 * 4) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(6.5, -3.2 + (1.5 * 5) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{ -- Row 2
			pos = Vector(2.85, -3.2, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(2.85, -3.2 + (1.5 * 2) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(2.85, -3.2 + (1.5 * 3) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(2.85, -3.2 + (1.5 * 4) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(2.85, -3.2 + (1.5 * 5) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},

		{ -- Row 3
			pos = Vector(-6.5, -3.2, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(-6.5, -3.2 + (1.5 * 2) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(-6.5, -3.2 + (1.5 * 3) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(-6.5, -3.2 + (1.5 * 4) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(-6.5, -3.2 + (1.5 * 5) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{ -- Row 4
			pos = Vector(-2.85, -3.2, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(-2.85, -3.2 + (1.5 * 2) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(-2.85, -3.2 + (1.5 * 3) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(-2.85, -3.2 + (1.5 * 4) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
		{
			pos = Vector(-2.85, -3.2 + (1.5 * 5) - 1.5, 3.8),
			ang = Angle(0, -90, 0)
		},
	}
end

function ENT:OnTakeDamage(damage)
	self:SetHealth(self:Health() - damage:GetDamage())
	if self:Health() <= 0 then
		self:Remove()
	end
end

function ENT:GetOpenSockets()
	if self.plugs == {} then return #self.sockets end

	local open = #self.sockets

	for k, v in pairs(self.plugs) do
		if IsValid(v) then
			open = open - 1
		else
			table.remove(self.plugs, k)
		end
	end

	return open
end

function ENT:GetAvaliableSocket()
	for k, v in pairs(self.sockets) do
		if self.plugs[k] == nil then return k end
	end
end

function ENT:PlugIn(ent)
	if ent:GetClass() != "fbm_asic" or ent == self.plug then return end
	if self:GetOpenSockets() <= 0 then return end

	local num = self:GetAvaliableSocket()

	local pos = self.sockets[num].pos
	local ang = self.sockets[num].ang

	ent:SetPos(self:LocalToWorld(pos or Vector()))
	ent:SetAngles(self:LocalToWorldAngles(ang or Angle()))
	ent:SetParent(self)

	self.plugs[num] = ent

	ent.socket = self
end

function ENT:UnPlug(ent)
	if ent:GetClass() != "fbm_asic" then return end

	for k, v in pairs(self.plugs) do
		if v == ent then
			self.plugs[k] = nil
			ent.socket = nil
			ent:SetParent()

			local pos = (self.sockets[k].pos or self:GetPos()) + Vector(0, 15, 0)
			local ang = self.sockets[k].ang

			ent:SetPos(self:LocalToWorld(pos))
		end
	end
end

function ENT:OnTakeDamage(damage)
	self:SetHealth(self:Health() - damage:GetDamage())
	if self:Health() <= 0 then
		self:Remove()
	end
end

function ENT:OnRemove()
    for k, v in pairs(self.plugs) do
			if not IsValid(v) then continue end

			v:SetParent()
			self:UnPlug(v)
		end

		self.plug:Remove()
end

function ENT:Think()
	if self.plug:HasPower() != self.HasPower then
		self.HasPower = self.plug:HasPower()

		self:SetHasPower(self.HasPower)
	end

	if #self.plugs != self:GetSticks() then
		self:SetSticks(#self.plugs)
	end

	if not self:GetHasPower() and self:GetIsActivated() then
		self:ChangeIsMining(false)
	end

	if self:GetIsActivated() then
		if CurTime() >= self.time + 1 then
			self.time = CurTime()

			local rate = FBM.CONFIG.StickRate or 0
			local amount = self:GetBitcoin() or 0

			rate = rate * #self.plugs

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

Test = {}
Test.__index = Test

function Test:new(Three, Bow)
	local Table = {
		Three = Three,
		Bow = Bow,
	}

	setmetatable( Table, Test )
	return Test
end
setmetatable( Test, { __call = Test.new } )
