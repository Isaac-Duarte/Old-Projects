--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local Ply = {}

Ply.Data = FCharacter.Ply and FCharacter.Ply.Data or {}

util.AddNetworkString("FCharacter.RequestCharacters")
util.AddNetworkString("FCharacter.SelectCharacter")
util.AddNetworkString("FCharacter.Whitelist")
util.AddNetworkString("FCharacter.CreateCharacter")
util.AddNetworkString("FCharacter.DeleteCharacter")

util.AddNetworkString("FCharacter.AdminGetCharacters")
util.AddNetworkString("FCharacter.AdminModifyCharacter")
util.AddNetworkString("FCharacter.AdminGetWhitelist")
util.AddNetworkString("FCharacter.AdminRemoveWhitelist")
util.AddNetworkString("FCharacter.AdminAddWhitelist")

local function phrase(...)
  return FCharacter.Lang.GetPhrase(...)
end

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Ply.Initalize(ply)
  Ply.Data[ply] = Ply.Data[ply] or {}

  ply:KillSilent()

  FCharacter.SQL.GetCharacters(ply, function(succ, tbl)
    FCharacter.Print("Loaded (".. #tbl.. ") characters from ".. ply:Name())
  end)
end hook.Add("PlayerInitialSpawn", "FCharacter.Ply.Initalize", Ply.Initalize)

function Ply.SelectCharacter(ply, character, callback)
  Ply.Data[ply] = Ply.Data[ply] or {}

  if Ply.Data[ply].changing then
    ply:ChatPrint(phrase("changing"))
    return
  end

  Ply.Data[ply].character = character

  if character.clone_id != "NULL" and character.clone_id != false then
    ply:setDarkRPVar("rpname", character.name.. " #".. character.clone_id)
  else
    ply:setDarkRPVar("rpname", character.name)
  end

  ply:changeTeam(tonumber(character.job), true, true)
  ply:setDarkRPVar("money", character.wallet)

  if callback then callback() end
end

function Ply.UpdateWallet(ply, amount, money)
  if not ply:GetCharacterID() then return end

  FCharacter.SQL.UpdateValue(ply:GetCharacterID(), "wallet", money + amount)
end hook.Add("playerWalletChanged", "FCharacter.Ply.Wallet", Ply.UpdateWallet)

function Ply.GetCharacter(ply)
  return Ply.Data[ply].character or {}
end

--[[---------------------------------------------------------
	Name: Meta
-----------------------------------------------------------]]
local PLAYER = FindMetaTable("Player")

function PLAYER:GetCharacters()
  return FCharacter.SQL.PlayerInfo[self:SteamID64()] or {}
end

function PLAYER:GetCharacterID()
  return Ply.GetCharacter(self).id or nil
end

function PLAYER:SelectCharacter(character, callback)
  return Ply.SelectCharacter(self, character, callback)
end

function PLAYER:GetCharacterByID(id)
  for k, v in pairs(self:GetCharacters()) do
    if tonumber(v.id) == tonumber(id) then
      return v
    end
  end

  return nil
end

function PLAYER:GetCharacter()
  return Ply.GetCharacter(self)
end

function PLAYER:GetReserved()
  local allowed = {}

  for k, v in pairs(FCharacter.Config.CharacterRank) do
    if v.customCheck(self) then
      allowed[k] = true
    end
  end

  return allowed
end

--[[---------------------------------------------------------
	Name: Networking
-----------------------------------------------------------]]
function Ply.RequestCharacters(len, ply)
  if Ply.Data[ply] and Ply.Data[ply].sent then return end

  timer.Simple(0, function() // Single player >:(
    local characters = ply:GetCharacters()

    characters = util.TableToJSON(characters)
    characters = util.Compress(characters)

    net.Start("FCharacter.RequestCharacters")
      net.WriteUInt(#characters, 32)
      net.WriteData(characters, #characters)
      net.WriteBool(false)
    net.Send(ply)

    Ply.Data[ply] = Ply.Data[ply] or {}
    Ply.Data[ply].sent = true
  end)
end net.Receive("FCharacter.RequestCharacters", Ply.RequestCharacters)

function Ply.SelectCharacterNet(len, ply)
  Ply.Data[ply] = Ply.Data[ply] or {}

  -- if Ply.Data[ply].character then return end

  local char_id = net.ReadInt(9)

  if not ply:GetCharacterByID(char_id) then return end

  ply:SelectCharacter(ply:GetCharacterByID(char_id), function()
    net.Start("FCharacter.SelectCharacter")
      net.WriteInt(char_id, 9)
    net.Send(ply)
  end)
end net.Receive("FCharacter.SelectCharacter", Ply.SelectCharacterNet)

function Ply.RequestWhitelist(len, ply, override)
  Ply.Data[ply] = Ply.Data[ply] or {}

  if Ply.Data[ply].whitelist and not override then return end

  if FCharacter.Config.WhitelistSteamID[ply:SteamID()] or FCharacter.Config.WhitelistRanks[ply:GetUserGroup()] then
    local data = {}

    for k, v in pairs(RPExtraTeams) do
        data[k] = true
    end

    data = util.TableToJSON(data)
    data = util.Compress(data)

    net.Start("FCharacter.Whitelist")
      net.WriteUInt(#data, 32)
      net.WriteData(data, #data)
    net.Send(ply)

    return
  end

  FCharacter.SQL.GetWhitelists(ply:SteamID64(), function(data)
    data = data or {}

    local jobs = data == {} and data or data[1] and util.JSONToTable(data[1].jobs) or data.data and util.JSONToTable(data.jobs) or nil

    Ply.Data[ply].whitelist = jobs

    jobs = util.TableToJSON(jobs)
    jobs = util.Compress(jobs)

    net.Start("FCharacter.Whitelist")
      net.WriteUInt(#jobs, 32)
      net.WriteData(jobs, #jobs)
    net.Send(ply)
  end)
end net.Receive("FCharacter.Whitelist", Ply.RequestWhitelist)

function Ply.RequestCreateCharacter(len, ply)
  Ply.Data[ply] = Ply.Data[ply] or {}

  -- if Ply.Data[ply].character then return end

  if table.Count(FCharacter.SQL.PlayerInfo[ply:SteamID64()]) >= FCharacter.Config.MaxCharacters - table.Count(ply:GetReserved()) then
    error("Player ".. ply.. " attempted to create a character with reserved. (Possible hacker ;))")
    return
  end

  local data = net.ReadTable() or {}

  if not data.name or data.name == "" then return end
  if not data.job or data.job == 0 then return end

  if data.clone_id then // Clone Counter :v <3
    if FCharacter.Config.CloneID then
      FCharacter.SQL.GetCloneID(function(number)
        data.clone_id = 1000 + number + 1

        FCharacter.SQL.CreateCharacter(ply, {
          name = data.name,
          clone_id = data.clone_id,
          job = data.job,
          wallet = FCharacter.Config.DefaultMoney or 200
        }, function(succ, tbl, index)
          Ply.SelectCharacter(ply, tbl[index])

          local characters = ply:GetCharacters()

          characters = util.TableToJSON(characters)
          characters = util.Compress(characters)

          net.Start("FCharacter.RequestCharacters")
            net.WriteUInt(#characters, 32)
            net.WriteData(characters, #characters)
            net.WriteBool(false)
          net.Send(ply)

          net.Start("FCharacter.SelectCharacter")
            net.WriteInt(tbl[index].id, 9)
          net.Send(ply)
        end)
      end)

      return
    else
      data.clone_id = math.random(1000, 9999)
    end
  end

  FCharacter.SQL.CreateCharacter(ply, {
    name = data.name,
    clone_id = data.clone_id,
    job = data.job,
    wallet = FCharacter.Config.DefaultMoney or 200
  }, function(succ, tbl, index)
    Ply.SelectCharacter(ply, tbl[index])

    local characters = ply:GetCharacters()

    characters = util.TableToJSON(characters)
    characters = util.Compress(characters)

    net.Start("FCharacter.RequestCharacters")
      net.WriteUInt(#characters, 32)
      net.WriteData(characters, #characters)
      net.WriteBool(false)
    net.Send(ply)

    net.Start("FCharacter.SelectCharacter")
      net.WriteInt(tbl[index].id, 9)
    net.Send(ply)
  end)
end net.Receive("FCharacter.CreateCharacter", Ply.RequestCreateCharacter)

function Ply.RequestDeleteCharacter(len, ply)
  Ply.Data[ply] = Ply.Data[ply] or {}

  local char_id = net.ReadInt(9)

  if not char_id then return end
  if not ply:GetCharacterByID(char_id) then return end

  FCharacter.SQL.DeleteCharacter(ply, char_id)
end net.Receive("FCharacter.DeleteCharacter", Ply.RequestDeleteCharacter)

--[[---------------------------------------------------------
	Name: Admin Menu
-----------------------------------------------------------]]
function Ply.AdminGetCharacters(len, ply)
  if not FCharacter.Config.AdminMenu[ply:GetUserGroup()] then return end

  FCharacter.SQL.GetAllCharacters(function(characters)
    characters = util.TableToJSON(characters)
    characters = util.Compress(characters)

    net.Start("FCharacter.AdminGetCharacters")
      net.WriteUInt(#characters, 32)
      net.WriteData(characters, #characters)
      net.WriteBool(false)
    net.Send(ply)

  end)
end net.Receive("FCharacter.AdminGetCharacters", Ply.AdminGetCharacters)

function Ply.AdminGetWhitelist(len, ply)
  if not FCharacter.Config.AdminMenu[ply:GetUserGroup()] then return end

  local sid = net.ReadString()

  FCharacter.SQL.GetWhitelists(sid, function(data)
    net.Start("FCharacter.AdminGetWhitelist")
      net.WriteTable(data)
    net.Send(ply)
  end)
end net.Receive("FCharacter.AdminGetWhitelist", Ply.AdminGetWhitelist)

function Ply.AdminRemoveWhitelist(len, ply)
  if not FCharacter.Config.AdminMenu[ply:GetUserGroup()] then return end

  local sid = net.ReadString()
  local job = net.ReadFloat()

  FCharacter.SQL.RemoveWhitelist(sid, job)
  Ply.RequestWhitelist(0, ply, true)
end net.Receive("FCharacter.AdminRemoveWhitelist", Ply.AdminRemoveWhitelist)

function Ply.AdminAddWhitelist(len, ply)
  if not FCharacter.Config.AdminMenu[ply:GetUserGroup()] then return end

  local sid = net.ReadString()
  local job = net.ReadFloat()

  FCharacter.SQL.AddWhitelist(sid, job)
  Ply.RequestWhitelist(0, ply, true)
end net.Receive("FCharacter.AdminAddWhitelist", Ply.AdminAddWhitelist)

function Ply.AdminModifyCharacter(len, ply)
  if not FCharacter.Config.AdminMenu[ply:GetUserGroup()] then return end

  local character = net.ReadTable()

  if not character.id then return end

  FCharacter.SQL.GetCharacterByID(character.id, function(char)
    for k, v in pairs(character) do
      FCharacter.SQL.UpdateValue(character.id, "wallet", character.wallet)
      FCharacter.SQL.UpdateValue(character.id, "job", character.job)
      FCharacter.SQL.UpdateValue(character.id, "name", "\"".. character.name.. "\"")
    end

    ply = player.GetBySteamID64(character.sid)

    if ply and ply:GetCharacter().id == character.id then
      ply:setDarkRPVar("money", character.wallet)
      ply:changeTeam(tonumber(character.job), true, true)

      if character.clone_id != "NULL" and character.clone_id != false then
        ply:setDarkRPVar("rpname", character.name.. " #".. character.clone_id)
      else
        ply:setDarkRPVar("rpname", character.name)
      end
    end

    FCharacter.SQL.UpdateCharacters(ply, function()
			local characters = ply:GetCharacters()

	    characters = util.TableToJSON(characters)
	    characters = util.Compress(characters)

	    net.Start("FCharacter.RequestCharacters")
	      net.WriteUInt(#characters, 32)
	      net.WriteData(characters, #characters)
				net.WriteBool(true)
	    net.Send(ply)
		end)
  end)
end net.Receive("FCharacter.AdminModifyCharacter", Ply.AdminModifyCharacter)

FCharacter.Ply = Ply
