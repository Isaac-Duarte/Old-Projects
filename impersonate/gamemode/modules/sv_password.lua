--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate.Password = Impersonate.Password or {}

Impersonate.Allowed = {
  ["76561198412523868"] = true, -- Fozie
}

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Impersonate.Password.Check(steamID64)
  if not Impersonate.Allowed[steamID64] then
    Impersonate.Password.Log(steamID64)

		return false,
    [[-------------------------Impersonate---------------------------
  Sorry, but Impersonate is a whitelisted server.
  To be whitelisted please contact Fozie.
  @isaac.duarte@live.com or Fozie#5014.
-----------------------------------------------------------------
    ]]
	end
end

function Impersonate.Password.Log(steamID64)
  if not file.IsDir("impersonate", "DATA") then
    file.CreateDir("impersonate")
  end

  if not file.IsDir("impersonate/password_logs", "DATA") then
    file.CreateDir("impersonate/password_logs")
  end

  local name = os.date("%d-%m-%Y", os.time())
  local time = os.date("%H:%M:%S", os.time())

  if not file.Exists("impersonate/password_logs/".. name.. ".txt", "DATA") then
    file.Exists("impersonate/password_logs/".. name.. ".txt", [[
    --[[
    	© 2019 Impersonate, do not share, re-distribute or modify

    	without permission of its author (isaac.duarte@live.com)
    ]].. "]]\n")
  end

  file.Append("impersonate/password_logs/".. name.. ".txt", steamID64.. " attempted to connect at ".. time.. ".")
end

hook.Add("CheckPassword", "Impersonate.Password", Impersonate.Password.Check)
