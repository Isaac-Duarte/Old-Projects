--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
require("mysqloo")

Impersonate.SQL = Impersonate.SQL or {}
Impersonate.SQL.Data = Impersonate.SQL.Data or {}
Impersonate.SQL.Characters = Impersonate.SQL.Characters or {}

Impersonate.SQL.BaseCharacter = [[
INSERT INTO `characters` (steamid64, id, first_name, last_name, sex, model, model_override, skin, body_groups, money, money_bank, physical_state, vehicles) VALUES (
  "%s",
  %s,
  "%s",
  "%s",
  "%s",
  "%s",
  "%s",
  %s,
  "%s",
  %s,
  %s,
  "%s",
  "%s"
)
]]

util.AddNetworkString("Impersonate.SQL.SendCharacters")
util.AddNetworkString("Impersonate.SQL.CreateCharacter")
util.AddNetworkString("Impersonate.SQL.SelectCharacter")

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Impersonate.SQL:InitialSpawn(pPlayer, cb) // Get player if any.
  if not pPlayer or not pPlayer:IsPlayer() then return end
  cb = cb or function() end

  Impersonate.SQL:GetCharacters(pPlayer, function(result)
    Impersonate.SQL.Characters[pPlayer] = result or {}

    self:SendPlayerCharacters(pPlayer)

    cb()
  end)
end

function Impersonate.SQL:PlayerDisconnected(pPlayer)
  if not Impersonate.SQL.Characters[pPlayer] then return end

  Impersonate.SQL.Characters[pPlayer] = nil
end

function Impersonate.SQL:GetCharacters(pPlayer, callback) // Get's players characters.
  if not pPlayer or not pPlayer:IsPlayer() then return end

  self:Query("SELECT * FROM `characters` WHERE steamid64 = ".. pPlayer:SteamID64(), function(succ, result)
    if succ then
      callback(result)
    else
      Impersonate.PrintError("MySQL", "Error while getting Characters. \nERROR: ".. result)
    end
  end)
end

function Impersonate.SQL:CreateCharacter(pPlayer, tData) // Create's a character for a player.
  if not pPlayer or not pPlayer:IsPlayer() then return end
  if not type(data) == "table" then return end
  if pPlayer.Character then return end

  if #self.Characters[pPlayer] > Impersonate.Config.MaxCharacters - 1 then return end

  local id = #self.Characters[pPlayer] + 1

  self:Query(string.format(self.BaseCharacter, pPlayer:SteamID64(), id, tData.first_name, tData.last_name, tData.sex, tData.model, "nil", 0, "[]", 500, 1000, "[]", "[]"), function(succ, result)
    if succ then
      Impersonate.SQL:InitialSpawn(pPlayer, function()
        net.Start("Impersonate.SQL.SendCharacters")
          net.WriteTable(Impersonate.SQL.Characters[pPlayer])
        net.Send(pPlayer)

        Impersonate.SQL:SelectCharacter(pPlayer, id)
      end)
    else
      Impersonate.PrintError("MySQL", "Error while trying to create a character for ".. pPlayer:Nick().. ". \nERROR: ".. result)
    end
  end)
end

function Impersonate.SQL:SendPlayerCharacters(pPlayer)
  if pPlayer.ImpersonateLoaded then return end

  net.Start("Impersonate.SQL.SendCharacters")
    net.WriteTable(Impersonate.SQL.Characters[pPlayer])
  net.Send(pPlayer)

  Impersonate.DebugPrint("MySQL", "Sent player ".. tostring(pPlayer).. " their characters.")

  pPlayer.ImpersonateLoaded = true
end

function Impersonate.SQL.SelectedCharacter(_, pPlayer)
  if pPlayer.Character then return end

  local character = net.ReadFloat()

  if character == 0 then return end

  character = Impersonate.SQL.Characters[pPlayer][character]

  if not character then return end

  pPlayer.Character = character
  Impersonate.Player:InitialSpawn(pPlayer)

  hook.Run("Impersonate.SQL.SelectedCharacter", pPlayer, character)

  net.Start("Impersonate.SQL.SelectCharacter")
    net.WriteFloat(character.id)
  net.Send(pPlayer)
end net.Receive("Impersonate.SQL.SelectCharacter", Impersonate.SQL.SelectedCharacter)

function Impersonate.SQL:SelectCharacter(pPlayer, intCharID)
  if pPlayer.Character then return end

  local character = Impersonate.SQL.Characters[pPlayer][intCharID]
  if not character then return end

  pPlayer.Character = character
  Impersonate.Player:InitialSpawn(pPlayer)

  hook.Run("Impersonate.SQL.SelectedCharacter", pPlayer, intCharID)

  net.Start("Impersonate.SQL.SelectCharacter")
    net.WriteFloat(intCharID)
  net.Send(pPlayer)
end

--[[
Impersonate.SQL:CreateCharacter(Entity(1), {
  first_name = "Isaiah",
  last_name = "Duarte",
  sex = "male",
  model = "models/player/mossman_arctic.mdl"
})]]
