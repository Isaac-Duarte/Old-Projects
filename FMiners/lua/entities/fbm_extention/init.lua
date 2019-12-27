AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/livinrp/plug_extension.mdl")
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

	self.plugs = {}

	self.sockets = {
		{
			pos = Vector(-5.4, 0, 4.2),
			ang = Angle(0, 0, 0)
		},
		{
			pos = Vector(-5.4 + (3), 0, 4.2),
			ang = Angle(0, 0, 0)
		},
		{
			pos = Vector(-5.4 + (3 * 2), 0, 4.2),
			ang = Angle(0, 0, 0)
		},
		{
			pos = Vector(-5.4 + (3 * 3), 0, 4.2),
			ang = Angle(0, 0, 0)
		},
		{
			pos = Vector(-5.4 + (3 * 4), 0, 4.2),
			ang = Angle(0, 0, 0)
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
	if self.plugs == {} then return #self.plugs end

	local open = #self.sockets

	for k, v in pairs(self.plugs) do
		if IsValid(v) then
			open = open - 1
		else
			self.plugs[k] = nil
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
	if ent:GetClass() != "fbm_plug" or ent == self.plug then return end
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
	if ent:GetClass() != "fbm_plug" then return end

	for k, v in pairs(self.plugs) do
		if v == ent then
			self.plugs[k] = nil
			ent.socket = nil
			ent:SetParent()

			local pos = (self.sockets[k].pos or self:GetPos()) + Vector(0, 10, 0)
			local ang = self.sockets[k].ang

			ent:SetPos(self:LocalToWorld(pos))
		end
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
	end
end
