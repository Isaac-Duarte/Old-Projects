--[[
	© 2019 DayZ, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
DayZ.Color = DayZ.Color or {}
DayZ.UI = DayZ.UI or {}

DayZ.Color.black = Color(0, 0, 0)
DayZ.Color.white = Color(255, 255, 255)
DayZ.Color.gray = Color(150, 150, 150)
DayZ.Color.red = Color(255, 0, 0)
DayZ.Color.green = Color(0, 255, 0)
DayZ.Color.blue = Color(0, 0, 255)
DayZ.Color.lightblue = Color(0, 125, 255)
DayZ.Color.pink = Color(255, 105, 180)
DayZ.Color.orange = Color(255, 125, 0)
DayZ.Color.yellow = Color(255, 255, 0)
DayZ.Color.purple = Color(138, 43, 226)

DayZ.Color._red = Color(255, 120, 120)
DayZ.Color._green = Color(120, 255, 120)
DayZ.Color._blue = Color(120, 120, 255)
DayZ.Color._yellow = Color(255, 255, 120)

function DayZ.UI.Color(sColor)
  return DayZ.Color[string.lower(sColor)] or Color(255, 255, 255)
end
