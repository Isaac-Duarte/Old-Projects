--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local PANEL = {}

--[[---------------------------------------------------------
	Name: Frame
-----------------------------------------------------------]]
function PANEL:Init()
  self:SetTitle("FCharacter Admin Menu")

  self.sheet = vgui.Create("DPropertySheet", self)
  self.sheet:Dock(FILL)

  self.sheet:AddSheet("Players", vgui.Create("FCharacter.Admin.Player", self))
  self.sheet:AddSheet("Characters", vgui.Create("FCharacter.Admin.Character", self))
end

vgui.Register("FCharacter.Admin", PANEL, "DFrame")

--[[---------------------------------------------------------
	Name: Player List
-----------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
  self.list = vgui.Create("DListView", self)

  self.list:Dock(FILL)

  self.list:AddColumn("SteamID")
  self.list:AddColumn("Name")

  for k, v in pairs(player.GetAll()) do
    local pnl = self.list:AddLine(v:SteamID64(), v:Nick())

    pnl.ply = v
    pnl.steamid = v:SteamID64()
  end

  self.list.DoDoubleClick = function(s, id, pnl)
    if self.edit and IsValid(self.edit) then
      self.edit:Remove()
    end

    self.edit = vgui.Create("FCharacter.Admin.Player.Whitelist")

    self.edit:SetSize(400, 300)
    self.edit:Center()
    self.edit:MakePopup()

    self.edit:SetTitle("Editing ".. (pnl.ply:Nick() or pnl.steamid).. "'s Whitelist")

    self.edit:SetPlayer(pnl.steamid)
  end
end

function PANEL:OnRemove()
  if self.edit and IsValid(self.edit) then
    self.edit:Remove()
  end
end

vgui.Register("FCharacter.Admin.Player", PANEL, "DPanel")

--[[---------------------------------------------------------
	Name: Whitelist Menu
-----------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
  self.whitelisted = vgui.Create("DListView", self)

  self.whitelisted:SetSize(200, 275)
  self.whitelisted:SetPos(0, 25)
  self.whitelisted:AddColumn("Whitelisted")

  self.whitelisted.OnRowRightClick = function(s, id, pnl)
    local menu = DermaMenu(self)

    menu:AddOption("Remove", function()
      local job = RPExtraTeams[tonumber(pnl.id)] and RPExtraTeams[tonumber(pnl.id)].name or "nil"

      local pnl2 = self.jobs:AddLine(job)
      pnl2.id = pnl.id

      self.whitelisted:RemoveLine(id)

      FCharacter.Ply.AdminRemoveWhitelist(self.sid, pnl.id)
    end):SetIcon("icon16/delete.png")

    menu:Open()
  end

  self.jobs = vgui.Create("DListView", self)

  self.jobs:SetSize(200, 275)
  self.jobs:SetPos(200, 25)
  self.jobs:AddColumn("Not Whitelisted")

  self.jobs.OnRowRightClick = function(s, id, pnl)
    local menu = DermaMenu(self)

    menu:AddOption("Add", function()
      local job = RPExtraTeams[tonumber(pnl.id)] and RPExtraTeams[tonumber(pnl.id)].name or "nil"

      local pnl2 = self.whitelisted:AddLine(job)
      pnl2.id = pnl.id

      self.jobs:RemoveLine(id)

      FCharacter.Ply.AdminAddWhitelist(self.sid, pnl.id)
    end):SetIcon("icon16/add.png")

    menu:Open()
  end
end

function PANEL:SetPlayer(sid)
  self.sid = sid

  FCharacter.Ply.AdminGetWhitelist(sid, function(data)
      local jobs = data == {} and data or data[1] and util.JSONToTable(data[1].jobs) or data.data and util.JSONToTable(data.jobs) or nil

      local _jobs = RPExtraTeams

      for k, v in pairs(jobs) do
        local job = RPExtraTeams[k] and RPExtraTeams[k].name or "nil"

        local pnl = self.whitelisted:AddLine(job)

        pnl.id = k
      end

      for k, v in pairs(_jobs) do
        if jobs[v.team] then continue end

        local pnl = self.jobs:AddLine(v.name)

        pnl.id = v.team
      end
  end)
end

vgui.Register("FCharacter.Admin.Player.Whitelist", PANEL, "DFrame")

--[[---------------------------------------------------------
	Name: Character List
-----------------------------------------------------------]]
PANEL = {}

function PANEL:Init()
  self.characters = {}

  self.list = vgui.Create("DListView", self)

  self.list:Dock(FILL)

  self.list:AddColumn("id")
  self.list:AddColumn("name")
  self.list:AddColumn("job")

  self.list.DoDoubleClick = function(s, id, pnl)
    if self.edit and IsValid(self.edit) then
      self.edit:Remove()
    end

    self.edit = vgui.Create("FCharacter.Admin.Character.Modification")

    self.edit:SetSize(200, 200)
    self.edit:Center()
    self.edit:MakePopup()

    self.edit:SetData(pnl.char or {}, pnl)
  end

  FCharacter.Ply.AdminGetCharacters(function(characters)
    if not self then return end

    self:SetData(characters)
  end)
end

function PANEL:SetData(data)
  self.characters = data

  for k, v in pairs(data) do
    local name = ""

    if v.clone_id != "NULL" and v.clone_id != false then
      name = v.name.. " #".. v.clone_id
    else
      name = v.name
    end

    local job = RPExtraTeams[tonumber(v.job)] and RPExtraTeams[tonumber(v.job)].name or "nil"

    local pnl = self.list:AddLine(v.id, name, job)

    pnl.char = v
  end
end

function PANEL:OnRemove()
  if self.edit and IsValid(self.edit) then
    self.edit:Remove()
  end
end

vgui.Register("FCharacter.Admin.Character", PANEL, "DPanel")

--[[---------------------------------------------------------
	Name: Character Modification
-----------------------------------------------------------]]
PANEL = {}

function PANEL:SetData(data, line)
  self.character = data

  local name = ""

  if data.clone_id != "NULL" and data.clone_id != false then
    name = data.name.. " #".. data.clone_id
  else
    name = data.name
  end

  self:SetTitle("Now editing ".. name)

  local skips = {
    id = true,
    sid = true,
    clone_id = true
  }

  local x = 0

  for k, v in pairs(self.character) do
    if skips[k] then continue end

    x = x + 1

    local label = vgui.Create("DLabel", self)

    label:SetPos(5, (25 + 20) * x - 20)
    label:SetText(k)

    local text = vgui.Create("DTextEntry", self)

    text:SetSize(195, 25)
    text:SetPos(2.5, (25 + 20) * x)
    text:SetText(v)
    text:SetUpdateOnType(true)
    text.OnValueChange = function(s, value)
      self.character[k] = value
    end
  end

  self.close = vgui.Create("DButton", self)

  self.close:SetSize(75, 20)
  self.close:AlignBottom(5)
  self.close:AlignLeft(5)
  self.close:SetText("Cancel")
  self.close.DoClick = function()
    self:Close()
  end

  self.apply = vgui.Create("DButton", self)

  self.apply:SetSize(75, 20)
  self.apply:AlignBottom(5)
  self.apply:AlignRight(5)
  self.apply:SetText("Apply")
  self.apply.DoClick = function()
    FCharacter.Ply.AdminModifyCharacter(self.character)

    line.char = self.character

    self:Close()
  end
end

vgui.Register("FCharacter.Admin.Character.Modification", PANEL, "DFrame")
