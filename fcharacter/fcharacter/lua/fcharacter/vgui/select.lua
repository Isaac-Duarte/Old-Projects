--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local PANEL = {}

local function phrase(...)
  return FCharacter.Lang.GetPhrase(...)
end

local mats = {
  add = Material("fcharacter/add.png"),
  sel = Material("fcharacter/select.png")
}

--[[---------------------------------------------------------
	Name: Panel
-----------------------------------------------------------]]
function PANEL:Init()
  self.buttons = {}
  self.donators = {}

  timer.Simple(0, function()
    self:Elements()
  end)
end

function PANEL:Elements()
  local w, h = self:GetSize()

  local reserved = LocalPlayer():GetReserved()
  local characters = LocalPlayer():GetCharacters()
  local amount = FCharacter.Config.MaxCharacters

  local space = (144 * amount)

  local skip = 0

  for i=1, amount do
    if i <= #characters then
      local button = vgui.Create("FCharacter.Select.EButton", self)

      button:SetSize(128, 128)
      button:SetPos(w / 2 - space / 2 + (i * 144 - 128), h / 2)
      button:SetCharacter(characters[i])

      table.insert(self.buttons, button)
    else
      local button = vgui.Create("FCharacter.Select.AButton", self)

      button:SetSize(128, 128)
      button:SetPos(w / 2 - space / 2 + (i * 144 - 128), h / 2)

      if i > amount - table.Count(reserved) then
        local num = i - amount + table.Count(reserved)

        button:SetReserved(table.GetKeys(reserved)[num])

        table.insert(self.donators, button)
      end
    end
  end
end

function PANEL:Paint(w, h)
  draw.SimpleText(phrase("title_top"), "fc_1", w / 2, h / 2 - 210, Color(255, 232, 31), 1, 1)
  draw.SimpleText(phrase("title_bottom"), "fc_1", w / 2, h / 2 - 150, Color(255, 232, 31), 1, 1)

  draw.SimpleText(phrase("tos"), "fc_2", w / 2, h / 2 - 60, Color(255, 232, 31), 1, 1)

  for k, v in pairs(self.buttons) do
    local x, y = v:GetPos()

    draw.SimpleText(v:GetName(), "fc_5", x + v:GetWide() / 2, y - 10, Color(255, 255, 255), 1, 1)
  end

  for k, v in pairs(self.donators) do
    local x, y = v:GetPos()

    draw.SimpleText("(".. v.reserved.name.. ")", "fc_5", x + v:GetWide() / 2, y + 10 + v:GetTall(), Color(255, 255, 255), 1, 1)
  end
end

vgui.Register("FCharacter.Select", PANEL, "DPanel")

--[[---------------------------------------------------------
	Name: Exsiting Button
-----------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
  self:SetText("")

  self.mdl = vgui.Create("DModelPanel", self)
  self.mdl:Dock(FILL)

  self.mdl.DoClick = function()
    FCharacter.Ply.SelectCharacter(self.char.id)
    self:GetParent():GetParent():Remove()
  end

  timer.Simple(0, function()
    self:Elements()
  end)
end

function PANEL:Elements()
  local w, h = self:GetSize()

  self.delete = vgui.Create("DButton", self)

  self.delete:SetSize(24, 24)
  self.delete:AlignRight(5)
  self.delete:AlignTop(5)
  self.delete:SetText("")
  self.delete:SetImage( "icon16/cross.png" )

  self.delete.Paint = function(s, w, h)
    draw.NoTexture()
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawOutlinedRect(0, 0, w, h)
  end

  self.delete.DoClick = function(s, w, h)
    Derma_Query(string.format(phrase("delete_text"), self.char.name), string.format(phrase("delete_title"), self.char.name),
      phrase("delete_accept"), function()
        FCharacter.Ply.DeleteCharacter(self.char.id)
      end,
      phrase("delete_deny"))
  end
end

function PANEL:SetCharacter(character)
  self.char = character

  local model = type(RPExtraTeams[tonumber(character.job)].model) == "table" and RPExtraTeams[tonumber(character.job)].model[1] or RPExtraTeams[tonumber(character.job)].model or "models/error.mdl"

  self.mdl:SetModel(model)

  local eyepos = self.mdl.Entity:GetBonePosition(self.mdl.Entity:LookupBone("ValveBiped.Bip01_Head1")) + Vector(0, 0, -2)
  eyepos:Add(Vector(0, 0, 2))

  self.mdl:SetLookAt(eyepos)
  self.mdl:SetCamPos(eyepos-Vector(-16, 0, 0))
  self.mdl.Entity:SetEyeTarget(eyepos-Vector(-16, 0, 0))

  function self.mdl:LayoutEntity(ent)
		if self.bAnimated then
			self:RunAnimation()
		end
  end
end

function PANEL:GetName()
  if not self.char then return "" end

  if self.char.clone_id != "NULL" and self.char.clone_id != false then
    return self.char.name.. " ".. self.char.clone_id
  else

    return self.char.name
  end

  return ""
end

function PANEL:Paint(w, h)
  surface.SetDrawColor(Color(255, 255, 255))

  surface.SetMaterial(mats.sel)
  surface.DrawTexturedRect(-3, -3, w + 6, h + 6)

  -- draw.SimpleText(self:GetName(), "fc_5", w / 2, 10, Color(60, 60, 60), 1, 1)
end

vgui.Register("FCharacter.Select.EButton", PANEL, "DButton")


--[[---------------------------------------------------------
	Name: Add Button
-----------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
  self:SetText("")

  self.DoClick = function()
    if self.allowed == false then return end

    self:GetParent():GetParent():SetPage(0x2)
  end
end

function PANEL:SetReserved(name)
    self.reserved = FCharacter.Config.CharacterRank[name]

    self.allowed = LocalPlayer():GetReserved()[name] or false
end

function PANEL:Paint(w, h)
  if self.reserved and not self.allowed then
    surface.SetDrawColor(Color(255, 200, 200))

    surface.SetMaterial(mats.add)
    surface.DrawTexturedRect(-3, -3, w + 6, h + 6)

    return
  end

  surface.SetDrawColor(Color(255, 255, 255))

  surface.SetMaterial(mats.add)
  surface.DrawTexturedRect(-3, -3, w + 6, h + 6)
end

vgui.Register("FCharacter.Select.AButton", PANEL, "DButton")
