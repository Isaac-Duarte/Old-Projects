--[[---------------------------------------------------------
	Name: Config
-----------------------------------------------------------]]
FCharacter.Config.Language = "en" -- Which language to use.

FCharacter.Config.DefaultMoney = 200 -- Default money for a character
FCharacter.Config.MaxCharacters = 5 -- Max characters per person
FCharacter.Config.MaxNameLength = 20 -- Max length for a players name
FCharacter.Config.Wait = 5 -- Delay between changing/creating characters
FCharacter.Config.CloneID = true -- if true the system will label cole ids in order.

FCharacter.Config.DefaultJobs = { -- Default whitelisted job(s)
  [1] = true,
  [9] = true
}

FCharacter.Config.WhitelistRanks = { -- Rank(s) that can access any job.
  ["admin"] = true,
}

FCharacter.Config.WhitelistSteamID = { -- SteamID(s) that can access any job.
  ["STEAM_0:0:0"] = false,
}

FCharacter.Config.AdminMenu = { -- This will determain who can access the admin menu.
  ["superadmin"] = true,
}

FCharacter.Config.CharacterRank = { -- Reserved Slots
  ["donator"] = {
    name = "Donator+",
    customCheck = function(ply)
      return table.HasValue({"donator"}, ply:GetUserGroup())
    end
  },
  ["admin"] = {
    name = "Admin+",
    customCheck = function(ply)
      return table.HasValue({"admin"}, ply:GetUserGroup())
    end
  }
}
