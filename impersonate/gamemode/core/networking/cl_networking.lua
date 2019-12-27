--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate.Net = Impersonate.Net or {}

Impersonate.Net.Vars = Impersonate.Net.Vars or {}

Impersonate.Net.Calls = {
  ["number"] = net.ReadFloat,
  ["angle"] = net.ReadAngle,
  ["bit"] = net.ReadBit,
  ["bool"] = net.ReadBool,
  ["color"] = net.ReadColor,
  ["entity"] = net.ReadEntity,
  ["string"] = net.ReadString,
  ["vector"] = net.ReadVector
}

local SHARED_VAR = 0x1
local VAR = 0x2

--[[---------------------------------------------------------
	Name: Networking Functions
-----------------------------------------------------------]]
function Impersonate.Net:GetGameVar(strVar)
  return self.Vars[strVar]
end

function Impersonate.Net:GetSharedGameVar(pPlayer, strVar)
  return self.Vars[pPlayer] and self.Vars[pPlayer][strVar]
end

function Impersonate.Net.HandleNet()
  local strType = net.ReadString()
  local intShared = net.ReadInt(8)
  local strRead = net.ReadString()
  local pPlayer = net.ReadEntity()
  local var = Impersonate.Net.Calls[strRead]()

  if intShared == SHARED_VAR then
    Impersonate.Net.Vars[pPlayer] = Impersonate.Net.Vars[pPlayer] or {}

    Impersonate.Net.Vars[pPlayer][strType] = var
  end

  if intShared == VAR then
    Impersonate.Net.Vars[strType] = var
  end
end

net.Receive("Impersonate.Net", Impersonate.Net.HandleNet)
