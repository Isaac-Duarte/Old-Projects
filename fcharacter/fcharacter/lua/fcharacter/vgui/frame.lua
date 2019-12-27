--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local PANEL = {}

local UI = {}

local SELECT_PAGE = 0x1
local CREATE_PAGE = 0x2

local mats = {
  bg = Material("fcharacter/background.png")
}

local function phrase(...)
  return FCharacter.Lang.GetPhrase(...)
end

--[[---------------------------------------------------------
	Name: Panel
-----------------------------------------------------------]]
function PANEL:Init()
  self:SetDraggable(false)
  self:ShowCloseButton(false)
  self:SetTitle("")

  timer.Simple(0, function()
    if not self or not self.Elements then return end

    self:Elements()
  end)
end

function PANEL:OnKeyCodeReleased(key)
  if key == KEY_F6 then
    FCharacter.Menu.Open()

    FCharacter.Menu.Wait = true

    timer.Simple(1, function()
      FCharacter.Menu.Wait = false
    end)
  end
end

function PANEL:Elements()
  local w, h = self:GetSize()

  self:SetPage(SELECT_PAGE)

  self.disconnect = vgui.Create("DButton", self)

  self.disconnect:SetSize(300, 74)
  self.disconnect:SetPos(ScrW() - 320, 20)
  self.disconnect:SetText(phrase("disconnect"))
  self.disconnect:SetFont("fc_3")
  self.disconnect:SetTextColor(Color(60, 60, 60))

  self.disconnect.Paint = function(s, w, h)
    if s:IsHovered() then
      draw.RoundedBox(0, 0, 0, w, h, Color(245, 222, 21))
    else
      draw.RoundedBox(0, 0, 0, w, h, Color(255, 232, 31))
    end
  end

  self.disconnect.DoClick = function()
    RunConsoleCommand("disconnect")
  end
end

function PANEL:SetPage(page)
  local w, h = self:GetSize()

  if page == SELECT_PAGE then
    if self.create then self.create:Remove() end
    if self.select then self.select:Remove() end

    self.select = vgui.Create("FCharacter.Select", self)

    self.select:SetSize(w, h)
    self.select:Center()
  end

  if page == CREATE_PAGE then
    if self.create then self.create:Remove() end
    if self.select then self.select:Remove() end

    self.create = vgui.Create("FCharacter.Create", self)

    self.create:SetSize(w, h)
    self.create:Center()
  end

  if self.disconnect then
    self.disconnect:MoveToFront()
  end
end

function PANEL:Paint(w, h)
  surface.SetDrawColor(Color(255, 255, 255))
  surface.SetMaterial(mats.bg)
  surface.DrawTexturedRect(0, 0, w, h)

  -- draw.SimpleText(phrase("title_top"), "fc_1", w / 2, h / 2 - 210, Color(255, 232, 31), 1, 1)
  -- draw.SimpleText(phrase("title_bottom"), "fc_1", w / 2, h / 2 - 150, Color(255, 232, 31), 1, 1)
end

vgui.Register("FCharacter.Frame", PANEL, "DFrame")

--[[---------------------------------------------------------
	Name: Prompt
-----------------------------------------------------------]]
function UI.Prompt(...)
  local frame = Derma_Query(...)

  function frame:Paint(w, h)

  end
end

FCharacter.UI = UI
