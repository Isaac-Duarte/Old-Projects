include("shared.lua")

local mat = Material("sprites/light_glow02_add")


function ENT:Initialize()
		self.col = Color(255, 93, 0)

		self.time = CurTime()

		self.activated = true
end

function ENT:Think()
	if CurTime() > self.time + 0.07 then
		self.time = CurTime()

		if self.col == Color(0, 0, 0) then
			self.col = Color(255, 93, 0)
		else
			self.col = Color(0, 0, 0)
		end
	end
end

function ENT:Draw()
	self:DrawModel()

	if self:GetHasPower() then
		render.SetMaterial(mat)
		render.DrawSprite(self:LocalToWorld(Vector(0, -3, 9)), 20, 20, Color(0, 255, 0))

		render.DrawSprite(self:LocalToWorld(Vector(-0.2, -11, 8.7)), 2, 2, Color(0, 255, 0))
		render.DrawSprite(self:LocalToWorld(Vector(0.2, -11, 8.7)), 2, 2, self.col)
	end
end
