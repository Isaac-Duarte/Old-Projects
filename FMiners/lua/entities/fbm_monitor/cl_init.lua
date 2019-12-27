include("shared.lua")

surface.CreateFont("fbm.monitor:1", {
	font = "Roboto",
	size = 70,
})

local TerminalBackground = Material("materials/fbm/monitor_background.png")

function ENT:Initialize()
	self.size = self:OBBMaxs()
end

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) > 300 then return end

	local pos = self:LocalToWorld(Vector(6.2, -self.size.y, self.size.z))
	local ang = self:LocalToWorldAngles(Angle(0, 90, 90))


	local w = self.size.y * 2 * 10
	local h = self.size.z * 10

	cam.Start3D2D(pos, ang, 0.1)
		draw.RoundedBox(0, 25, 25, w - 50, h - 50, Color(48, 10, 36))

		surface.SetDrawColor(Color(255, 255, 255, 50))
		surface.SetMaterial(TerminalBackground)
		surface.DrawTexturedRect(-20, 0, w + 40, h)

		draw.SimpleText("$".. math.Round(FBM.CONFIG.BCPrice, 2), "fbm.monitor:1", w / 2, h / 2, Color(255, 255, 255), 1, 1)
	cam.End3D2D()
end
