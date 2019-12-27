--[[
	© 2019 DayZ, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
DayZ.Password = DayZ.Password or {}

DayZ.Allowed = {
  ["76561198412523868"] = true, -- Fozie
}

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function DayZ.Password.Check(steamID64)
  if not DayZ.Allowed[steamID64] then
    DayZ.Password.Log(steamID64)

		return false,
    [[-------------------------DayZ---------------------------
  Sorry, but DayZ is a whitelisted server.
  To be whitelisted please contact Fozie.
  @isaac.duarte@live.com or Fozie#5014.
-----------------------------------------------------------------
    ]]
	end
end

function DayZ.Password.Log(steamID64)
  if not file.IsDir("dayz", "DATA") then
    file.CreateDir("dayz")
  end

  if not file.IsDir("dayz/password_logs", "DATA") then
    file.CreateDir("dayz/password_logs")
  end

  local name = os.date("%d-%m-%Y", os.time())
  local time = os.date("%H:%M:%S", os.time())

  if not file.Exists("dayz/password_logs/".. name.. ".txt", "DATA") then
    file.Exists("dayz/password_logs/".. name.. ".txt", [[
    --[[
    	© 2019 DayZ, do not share, re-distribute or modify

    	without permission of its author (isaac.duarte@live.com)
    ]].. "]]\n")
  end

  file.Append("dayz/password_logs/".. name.. ".txt", steamID64.. " attempted to connect at ".. time.. ".")
end

hook.Add("CheckPassword", "DayZ.Password", DayZ.Password.Check)
