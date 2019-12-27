--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local Whitelist = {}

local function phrase(...)
  return FCharacter.Lang.GetPhrase(...)
end

--playerCanChangeTeam
--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Whitelist.ChangeTeam(ply, team, force)
  if force then return end
  if FCharacter.Config.WhitelistSteamID[ply:SteamID()] or FCharacter.Config.WhitelistRanks[ply:GetUserGroup()] then
    return true
  else
    return false, phrase("whitelist_fail")
  end

end hook.Add("playerCanChangeTeam", "FCharacter.Whitelist.ChangeTeam", Whitelist.ChangeTeam)

function Whitelist.ChangeName(ply, name)
  return false, "You can't change your name."
end hook.Add("CanChangeRPName", "FCharacter.Whitelist.ChangeName", Whitelist.ChangeName)

FCharacter.Whitelist = Whitelist
