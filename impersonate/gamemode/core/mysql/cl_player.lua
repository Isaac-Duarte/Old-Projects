--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate.SQL = Impersonate.SQL or {}

Impersonate.SQL._data = Impersonate.SQL._data or {}

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Impersonate.SQL.ReceiveCharacters()
  local characters = net.ReadTable() or {}

  Impersonate.DebugPrint("SQL", "Received Characters. (".. #characters.. ")")

  Impersonate.SQL._data.Characters = characters

  hook.Run("Impersonate.SQL.ReceivedCharacters", characters)
end net.Receive("Impersonate.SQL.SendCharacters", Impersonate.SQL.ReceiveCharacters)
