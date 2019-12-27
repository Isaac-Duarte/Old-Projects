--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]

local ply = nil
local _LocalPlayer = LocalPlayer

function LocalPlayer()
	ply = _LocalPlayer()

  if IsValid(ply) then
    LocalPlayer = function()
      return ply
    end
  end

	return ply
end
