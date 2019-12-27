--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local Ply = {}

Ply.Characters = FCharacter.Ply and FCharacter.Ply.Characters or {}
Ply.Character = FCharacter.Ply and FCharacter.Ply.Character or nil

Ply.Whitelist = FCharacter.Ply and FCharacter.Ply.Whitelist or nil

--[[---------------------------------------------------------
	Name: Networking
-----------------------------------------------------------]]
function Ply.Initalize()
  net.Start("FCharacter.RequestCharacters")
  net.SendToServer()
end

function Ply.ReceiveCharacters()
  local len = net.ReadUInt(32)
  local characters = net.ReadData(len)
  local update = net.ReadBool()

  characters = util.Decompress(characters)
  characters = util.JSONToTable(characters)

  Ply.Characters = characters

  for k, v in pairs(Ply.Characters) do
    if not v.id then
      table.remove(Ply.Characters, k)
    end
  end

  print("Received characters (".. string.NiceSize(len).. ")")

  if FCharacter.Menu.Menu and update then
    FCharacter.Menu.Menu:Remove()
    FCharacter.Menu.Open()
  end

end net.Receive("FCharacter.RequestCharacters", Ply.ReceiveCharacters)

function Ply.SelectCharacter(char_id)
  -- if Ply.Character then return end

  net.Start("FCharacter.SelectCharacter")
    net.WriteInt(char_id, 9) -- Only limits the ability to have 255 characters. Change if needed https://wiki.garrysmod.com/page/net/WriteInt
  net.SendToServer()
end

function Ply.SelectedCharacter()
  Ply.Character = LocalPlayer():GetCharacterByID(net.ReadInt(9))
end net.Receive("FCharacter.SelectCharacter", Ply.SelectedCharacter)

function Ply.GetWhitelist(callback)
  if Ply.Whitelist and callback then
    callback(Ply.Whitelist)

    return
  end

  net.Start("FCharacter.Whitelist")
  net.SendToServer()

  net.Receive("FCharacter.Whitelist", function()
    local len = net.ReadUInt(32)
    local whitelist = net.ReadData(len)
    whitelist = util.Decompress(whitelist)
    whitelist = util.JSONToTable(whitelist)

    Ply.Whitelist = whitelist

    if callback then
      callback(whitelist)
      callback = nil
    end
  end)
end

function Ply.UpdateWhitelist()
  local len = net.ReadUInt(32)
  local whitelist = net.ReadData(len)
  whitelist = util.Decompress(whitelist)
  whitelist = util.JSONToTable(whitelist)

  Ply.Whitelist = whitelist
end net.Receive("FCharacter.Whitelist", Ply.UpdateWhitelist)

function Ply.CreateCharacter(tbl)
  -- if Ply.Character then return end

  if not tbl.name or tbl.name == "" then return end
  if not tbl.job or tbl.job == 0 then return end

  net.Start("FCharacter.CreateCharacter")
    net.WriteTable(tbl)
  net.SendToServer()
end

function Ply.DeleteCharacter(char_id)
  if not LocalPlayer():GetCharacterByID(char_id) then return end

  net.Start("FCharacter.DeleteCharacter")
    net.WriteInt(char_id, 9) -- Only limits the ability to have 255 characters. Change if needed https://wiki.garrysmod.com/page/net/WriteInt
  net.SendToServer()
end

--[[---------------------------------------------------------
	Name: Meta
-----------------------------------------------------------]]
local PLAYER = FindMetaTable("Player")

function PLAYER:GetCharacters()
  return Ply.Characters
end

function PLAYER:GetCharacterByID(id)
  for k, v in pairs(self:GetCharacters()) do
    if tonumber(v.id) == tonumber(id) then
      return v
    end
  end

  return nil
end

function PLAYER:GetReserved()
  local allowed = {}

  for k, v in pairs(FCharacter.Config.CharacterRank) do
    if not v.customCheck(self) then
      allowed[k] = false
    end
  end

  return allowed or {}
end

Ply.Initalize()

--[[---------------------------------------------------------
	Name: Admin Menu
-----------------------------------------------------------]]
function Ply.AdminGetCharacters(callback)
  net.Start("FCharacter.AdminGetCharacters")
  net.SendToServer()

  net.Receive("FCharacter.AdminGetCharacters", function()
    local len = net.ReadUInt(32)
    local characters = net.ReadData(len)
    local update = net.ReadBool()

    characters = util.Decompress(characters)
    characters = util.JSONToTable(characters)

    if callback then callback(characters) end
  end)
end

function Ply.AdminGetWhitelist(sid, callback)
  if not sid then return end

  net.Start("FCharacter.AdminGetWhitelist")
    net.WriteString(tostring(sid))
  net.SendToServer()

  net.Receive("FCharacter.AdminGetWhitelist", function()
    local whitelist = net.ReadTable()

    if callback then callback(whitelist) end
  end)
end

function Ply.AdminRemoveWhitelist(sid, job)
  if not sid or not job then return end
  if not tonumber(job) then return end

  net.Start("FCharacter.AdminRemoveWhitelist")
    net.WriteString(tostring(sid))
    net.WriteFloat(tonumber(job))
  net.SendToServer()
end

function Ply.AdminAddWhitelist(sid, job)
  if not sid or not job then return end
  if not tonumber(job) then return end

  net.Start("FCharacter.AdminAddWhitelist")
    net.WriteString(tostring(sid))
    net.WriteFloat(tonumber(job))
  net.SendToServer()
end

function Ply.AdminModifyCharacter(character)
  if not character then return end

  net.Start("FCharacter.AdminModifyCharacter")
    net.WriteTable(character)
  net.SendToServer()
end

FCharacter.Ply = Ply
