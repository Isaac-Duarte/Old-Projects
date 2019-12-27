--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]

--[[---------------------------------------------------------
	Name: Main
-----------------------------------------------------------]]
local PANEL = {}

function PANEL:Init()

  timer.Simple(0, function()
    if not self then return end

    self:Elements()
  end)
end

function PANEL:Elements()
  local w, h = self:GetSize()
  if #Impersonate.SQL._data.Characters > 0 then
    for k, v in pairs(Impersonate.SQL._data.Characters) do
      self.create = vgui.Create("Impersonate.ChooseCharacters.Char", self)

      self.create:SetSize(ScrW() / 3, ScrH())
      self.create:SetPos(ScrW() / 3 * (k - 1), 0)
      self.create:SetHasCharacters(true)
      self.create:SetData(v)
    end

    if #Impersonate.SQL._data.Characters < Impersonate.Config.MaxCharacters then
      self.create = vgui.Create("Impersonate.ChooseCharacters.Char", self)

      self.create:SetSize(ScrW() / 3, ScrH())
      self.create:SetPos(ScrW() / 3 * (#Impersonate.SQL._data.Characters), 0)
      self.create:SetHasCharacters(false)
    end
  else
    self.create = vgui.Create("Impersonate.ChooseCharacters.Char", self)

    self.create:SetSize(ScrW() / 3, ScrH())
    self.create:SetPos(0, 0)
    self.create:SetHasCharacters(false)
  end

  self.exbutton = vgui.Create("DButton", self)

  self.exbutton:SetText("")
  self.exbutton:SetSize(200, 65)
  self.exbutton:AlignRight(0)
  self.exbutton:AlignTop(0)

  self.exbutton.Paint = function(s, w, h)
    if self:IsHovered() then
      draw.RoundedBox(0, 0, 0, w, h, Color(231, 76, 60))
    else
      draw.RoundedBox(0, 0, 0, w, h, Color(224, 72, 55))
    end

    draw.SimpleText("Disconnect", "Impersonate_25", w / 2, h / 2, Color(255, 255, 255), 1, 1)
  end

  self.exbutton.DoClick = function()
    LocalPlayer():ConCommand("Disconnect")
  end
end

function PANEL:Paint(w, h)
  draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200))
end

vgui.Register("Impersonate.ChooseCharacters", PANEL, "DFrame")

--[[---------------------------------------------------------
	Name: Elements
-----------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
  self:SetText("")

  self.HasCharacters = false
  self.data = {}
end

function PANEL:SetData(data)
  self.data = data
end

function PANEL:SetHasCharacters(can)
  self.HasCharacters = can
end

function PANEL:DoClick()
  if self.HasCharacters and not self.clicked then
    self.clicked = true

    net.Start("Impersonate.SQL.SelectCharacter")
      net.WriteFloat(self.data.id)
    net.SendToServer()
  else
    -- Open Creation Menu
  end
end

function PANEL:Paint(w, h)
  if self:IsHovered() then
    draw.RoundedBox(0, 0, 0, w, h, Color(140, 140, 140, 150))
  else
    draw.RoundedBox(0, 0, 0, w, h, Color(180, 180, 180, 150))
  end

  if not self.HasCharacters then
    draw.SimpleText("Create character", "Impersonate_25", w / 2, h / 2, Color(255, 255, 255), 1, 1)
  else
    draw.SimpleText(self.data.first_name .. " ".. self.data.last_name, "Impersonate_25", w / 2, h / 2, Color(255, 255, 255), 1, 1)
  end
end

vgui.Register("Impersonate.ChooseCharacters.Char", PANEL, "DButton")
