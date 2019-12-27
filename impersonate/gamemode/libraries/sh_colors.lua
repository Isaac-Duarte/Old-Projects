--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate.Color = Impersonate.Color or {}
Impersonate.UI = Impersonate.UI or {}

Impersonate.Color.black = Color(0, 0, 0)
Impersonate.Color.white = Color(255, 255, 255)
Impersonate.Color.gray = Color(150, 150, 150)
Impersonate.Color.red = Color(255, 0, 0)
Impersonate.Color.green = Color(0, 255, 0)
Impersonate.Color.blue = Color(0, 0, 255)
Impersonate.Color.lightblue = Color(0, 125, 255)
Impersonate.Color.pink = Color(255, 105, 180)
Impersonate.Color.orange = Color(255, 125, 0)
Impersonate.Color.yellow = Color(255, 255, 0)
Impersonate.Color.purple = Color(138, 43, 226)

Impersonate.Color._red = Color(255, 120, 120)
Impersonate.Color._green = Color(120, 255, 120)
Impersonate.Color._blue = Color(120, 120, 255)
Impersonate.Color._yellow = Color(255, 255, 120)

function Impersonate.UI.Color(sColor)
  return Impersonate.Color[string.lower(sColor)] or Color(255, 255, 255)
end
