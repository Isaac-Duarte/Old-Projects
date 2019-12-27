--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local PANEL = {}

local function phrase(...)
  return FCharacter.Lang.GetPhrase(...)
end

--[[---------------------------------------------------------
	Name: Panel
-----------------------------------------------------------]]
function PANEL:Init()
  self.character = {
    name = "John Doe",
    job = 0,
    clone_id = false
  }

  timer.Simple(0, function()
    self:Elements()
  end)
end

function PANEL:Elements()
  local w, h = self:GetSize()

  self.id = vgui.Create("FCharacter.CheckBox", self)

  self.id:SetSize(45, 45)
  self.id:SetPos(w / 2 - 175, h / 2 - 25)

  self.id.onChanged = function(value)
    self.character.clone_id = value
  end

  self.name = vgui.Create("FCharacter.TextEntry", self)

  self.name:SetSize(200, 45)
  self.name:SetPos(w / 2 - 325, h / 2 + 75)

  self.jobs = vgui.Create("FCharacter.JobList", self)

  self.jobs:SetSize(300, 350)
  self.jobs:SetPos(w / 2 - 120, h / 2 - 25)

  self.jobs.onSelected = function(job)
    self.model:SetJob(job)
  end

  self.model = vgui.Create("FCharacter.Character", self)

  self.model:SetSize(200, 350)
  self.model:SetPos(w / 2 + 200, h / 2 - 25)

  self.back = vgui.Create("FCharacter.HoverButton", self)

  self.back:SetColor(Color(62, 62, 62))
  self.back:SetText(phrase("return"))
  self.back:SetSize(90, 45)
  self.back:SetPos(w / 2 - 325, h / 2 + 280)

  self.back.DoClick = function()
    self:GetParent():SetPage(0x1)
  end

  self.create = vgui.Create("FCharacter.HoverButton", self)

  self.create:SetColor(Color(62, 62, 62))
  self.create:SetText(phrase("create"))
  self.create:SetSize(90, 45)
  self.create:SetPos(w / 2 - 215, h / 2 + 280)

  self.create.DoClick = function()
    if not self.character.name or self.character.name == "" then return end
    if not self.character.job or self.character.job == 0 then return end

    FCharacter.Ply.CreateCharacter(self.character)
    self:GetParent():Close()
  end
end

function PANEL:Paint(w, h)
  draw.SimpleText(phrase("character_top"), "fc_1", w / 2, h / 2 - 240, Color(255, 232, 31), 1, 1)
  draw.SimpleText(phrase("character_bottom"), "fc_1", w / 2, h / 2 - 180, Color(255, 232, 31), 1, 1)

  draw.SimpleText(phrase("clone_id"), "fc_3", w / 2 - 220, h / 2 - 50, Color(255, 232, 31), 1, 1)
  draw.SimpleText(phrase("name"), "fc_3", w / 2 - 220 , h / 2 + 50, Color(255, 232, 31), 1, 1)
  draw.SimpleText(phrase("job"), "fc_3", w / 2 + 30 , h / 2 - 50, Color(255, 232, 31), 1, 1)
  draw.SimpleText(phrase("model"), "fc_3", w / 2 + 300 , h / 2 - 50, Color(255, 232, 31), 1, 1)
end

vgui.Register("FCharacter.Create", PANEL, "DPanel")

--[[---------------------------------------------------------
	Name: Check Box
-----------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
  self.tick = false

  self:SetText("")
end

function PANEL:DoClick()
  self.tick = not self.tick

  if self.onChanged then
    self.onChanged(self.tick)
  end
end

function PANEL:Paint(w, h)
  draw.RoundedBox(0, 0, 0, w, h, Color(62, 62, 62))

  if self.tick then
    draw.RoundedBox(0, 4, 4, w - 8, h - 8, Color(255, 232, 31))
  end
end

vgui.Register("FCharacter.CheckBox", PANEL, "DButton")

--[[---------------------------------------------------------
	Name: Text Entry
-----------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
  self:SetText("John Doe")
  self:SetFont("fc_5")

  self:SetUpdateOnType(true)
end

function PANEL:Paint(w, h)
  draw.RoundedBox(0, 0, 0, w, h, Color(62, 62, 62))

  self:DrawTextEntryText(Color(255, 232, 31), Color(255, 255, 255, 100), Color(255, 255, 255))
end

function PANEL:OnValueChange(value)
  if #value > FCharacter.Config.MaxNameLength then

    self:SetText(string.sub(value, 1, FCharacter.Config.MaxNameLength))
    self:SetEditable(false)

    timer.Simple(0, function()
      self:SetEditable(true)
    end)
  end

  self:GetParent().character.name = value
end

vgui.Register("FCharacter.TextEntry", PANEL, "DTextEntry")

--[[---------------------------------------------------------
	Name: Job List
-----------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
  self.jobs = {}
  self.buttons = {}

  self.scroll = vgui.Create("DScrollPanel", self)

  self.scroll:Dock(FILL)

  timer.Simple(0, function()
    FCharacter.Ply.GetWhitelist(function(whitelist)
      for k, v in pairs(FCharacter.Config.DefaultJobs) do
        whitelist[k] = v
      end

      self:SetJobs(whitelist)
    end)
  end)
end

function PANEL:SetJobs(tbl)
  self.jobs = tbl or {}

  self:UpdateList()
end

function PANEL:UpdateList()
  local w, h = self:GetSize()

  for k, v in pairs(self.buttons) do
    v:Remove()
  end

  local x = 0

  for k, v in pairs(self.jobs) do
    if not RPExtraTeams[k] then continue end
    x = x + 1

    local job = RPExtraTeams[k]

    local button = vgui.Create("DButton", self.scroll)

    button:SetSize(w, 32)
    button:SetPos(0, 32 * x - 32)
    button:SetText(job.name)
    button:SetFont("fc_4")
    button:SetTextColor(Color(255, 232, 31))

    button.Paint = function(s, w, h)
      if s:IsHovered() then
        draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70))
      end

      if s.selected then
        draw.RoundedBox(0, 0, 0, w, h, Color(80, 80, 80))
      end
    end

    button.DoClick = function()
      for k, v in pairs(self.buttons) do
        v.selected = false
      end

      button.selected = true

      self:GetParent().character.job = job.team

      if self.onSelected then
        self.onSelected(job)
      end
    end

    table.insert(self.buttons, button)
  end
end

function PANEL:Paint(w, h)
  draw.RoundedBox(0, 0, 0, w, h, Color(62, 62, 62))
end

vgui.Register("FCharacter.JobList", PANEL, "DPanel")

--[[---------------------------------------------------------
	Name: Character Preview
-----------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
  self.mdl = vgui.Create("DModelPanel", self)
  self.mdl:Dock(FILL)

  function self.mdl:LayoutEntity(ent)
    return
  end
end

function PANEL:SetJob(tbl)
  local model = type(tbl.model) == "table" and tbl.model[1] or tbl.model or "models/error.mdl"

  self.mdl:SetModel(model)

  local mn, mx = self.mdl.Entity:GetRenderBounds()
  local size = 0
  size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
  size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
  size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

  self.mdl:SetFOV(24)
  self.mdl:SetCamPos(Vector(size, size, size))
  self.mdl:SetLookAt((mn + mx) * 0.5)

  function self.mdl:LayoutEntity(ent)
    ent:SetAngles(Angle(0, 45, 0))
  end
end

function PANEL:Paint(w, h)
  draw.RoundedBox(0, 0, 0, w, h, Color(62, 62, 62))
end

vgui.Register("FCharacter.Character", PANEL, "DPanel")

--[[---------------------------------------------------------
	Name: Hover Button
-----------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
  self.color = Color(255, 255, 255)
  self.hover = Color(255, 255, 255)

  self:SetFont("fc_4")
  self:SetTextColor(Color(255, 232, 31))
end

function PANEL:Paint(w, h)
  if self:IsHovered() then
    draw.RoundedBox(0, 0, 0, w, h, self.hover)
  else
    draw.RoundedBox(0, 0, 0, w, h, self.color)
  end
end

function PANEL:SetColor(color, hover)
  self.color = color or Color(62, 62, 62)
  self.hover = hover or Color(color.r + 10, color.g + 10, color.b + 10)
end

vgui.Register("FCharacter.HoverButton", PANEL, "DButton")
