AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/livinrp/plug_socket.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if IsValid(phys) then
		phys:Wake()
	end

	self.plugs = {}

	self.sockets = {
		{
			pos = Vector(-1.7, 2, 0),
			ang = Angle(180, 180, 90)
		},
		{
			pos = Vector(2.1, 2, 0),
			ang = Angle(180, 180, 90)
		}
	}

	self.HasPower = true
end

function ENT:GetOpenSockets()
	if self.plugs == {} then return 2 end

	local open = 2

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
	if self.plugs[1] == nil then return 1 end
	if self.plugs[2] == nil then return 2 end
end

function ENT:PlugIn(ent)
	if ent:GetClass() != "fbm_plug" then return end
	if self:GetOpenSockets() <= 0 then return end

	local num = self:GetAvaliableSocket()

	local pos = self.sockets[num].pos
	local ang = self.sockets[num].ang

	ent:SetPos(self:LocalToWorld(pos or Vector()))
	ent:SetAngles(self:LocalToWorldAngles(ang or Angle()))
	ent:SetParent(self)

	table.insert(self.plugs, num, ent)

	ent.socket = self
end

function ENT:UnPlug(ent)
	if ent:GetClass() != "fbm_plug" then return end

	for k, v in pairs(self.plugs) do
		if v == ent then
			self.plugs[k] = nil
			ent.socket = nil
			ent:SetParent()

			local pos = (self.sockets[k].pos or self:GetPos()) + Vector(0, 5, 0)
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
end
