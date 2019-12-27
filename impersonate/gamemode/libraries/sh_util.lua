--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]

local name = "[Impersonate %s]: "

local hide = {
  ["Jobs"] = true
}

function Impersonate.DebugPrint(file, ...)
  if hide[file] then return end

  MsgC(Impersonate.UI.Color("_yellow"), string.format(name, file), Color(255, 255, 255), ..., "\n")
end

function Impersonate.Print(...)
  MsgC(Impersonate.UI.Color("_blue"), Color(255, 255, 255), name, ..., "\n")
end

function Impersonate.PrintError(file, ...)
  MsgC(Impersonate.UI.Color("_red"), string.format(name, file), Color(255, 255, 255), ..., "\n")
end

function Impersonate.PrintWarning(...)
  MsgC(Impersonate.UI.Color("_yellow"), Color(255, 255, 255), name, ..., "\n")
end

function Impersonate.PrintSuccess(...)
  MsgC(Impersonate.UI.Color("_green"), Color(255, 255, 255), name, ..., "\n")
end
