--[[
	© 2019 DayZ, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]

local name = "[DayZ %s]: "

local hide = {}

function DayZ.DebugPrint(file, ...)
  if hide[file] then return end

  MsgC(DayZ.UI.Color("_yellow"), string.format(name, file), Color(255, 255, 255), ..., "\n")
end

function DayZ.Print(...)
  MsgC(DayZ.UI.Color("_blue"), Color(255, 255, 255), name, ..., "\n")
end

function DayZ.PrintError(file, ...)
  MsgC(DayZ.UI.Color("_red"), string.format(name, file), Color(255, 255, 255), ..., "\n")
end

function DayZ.PrintWarning(...)
  MsgC(DayZ.UI.Color("_yellow"), Color(255, 255, 255), name, ..., "\n")
end

function DayZ.PrintSuccess(...)
  MsgC(DayZ.UI.Color("_green"), Color(255, 255, 255), name, ..., "\n")
end
