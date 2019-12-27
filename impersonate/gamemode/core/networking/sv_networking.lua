--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate.Net = Impersonate.Net or {}

Impersonate.Net.Vars = Impersonate.Net.Vars or {}
Impersonate.Net.VarData = Impersonate.Net.VarData or {}

Impersonate.Net.Calls = {
  ["number"] = net.WriteFloat,
  ["angle"] = net.WriteAngle,
  ["bit"] = net.WriteBit,
  ["bool"] = net.WriteBool,
  ["color"] = net.WriteColor,
  ["entity"] = net.WriteEntity,
  ["string"] = net.WriteString,
  ["vector"] = net.WriteVector
}

local SHARED_VAR = 0x1
local VAR = 0x2

--[[---------------------------------------------------------
	Name: Networking Functions
-----------------------------------------------------------]]
util.AddNetworkString("Impersonate.net")

function Impersonate.Net:ValidType(var)
  if not self.Calls[type(var)] then return end

  return true
end

function Impersonate.Net:GetWriteFunction(var)
  return self.Calls[type(var)]
end

function Impersonate.Net:GetGameVar(strVar)
  return self.VarData[pPlayer] and self.Vars[pPlayer][strVar]
end

function Impersonate.Net:GetSharedGameVar(pPlayer, strVar)
  return self.VarData[pPlayer] and self.Vars[pPlayer][strVar]
end

function Impersonate.Net:RegisterGameVar(strName, strType)
  if self.Vars[strName] then return end
  if not self.Calls[string.lower(strType)] then return end

  self.Vars[strName] = strType
  self.VarData[strName] = {}
end

function Impersonate.Net:UpdateGameVar(pPlayer, strVar, var)
  print(pPlayer, strVar, var)
  if not self:ValidType(var) then return end
  if not self.Vars[strVar] then return end
  if self.VarData[strVar][pPlayer] == var then return end

  local write = self:GetWriteFunction(var)

  net.Start("Impersonate.Net")
    net.WriteString(strVar)
    net.WriteUInt(VAR, 8)
    net.WriteString(type(var))
    net.WriteEntity(pPlayer)
    write(var)
  net.Send(pPlayer)

  self.VarData[strVar][pPlayer] = var
end

function Impersonate.Net:UpdateSharedGameVar(pPlayer, strVar, var)
  print(pPlayer, strVar, var)
  if not self:ValidType(var) then return end
  if not self.Vars[strVar] then return end
  if self.VarData[strVar][pPlayer] == var then return end

  local write = self:GetWriteFunction(var)

  net.Start("Impersonate.Net")
    net.WriteString(strVar)
    net.WriteUInt(SHARED_VAR, 8)
    net.WriteString(type(var))
    net.WriteEntity(pPlayer)
    write(var)
  net.Broadcast()

  self.VarData[strVar][pPlayer] = var
end

--[[---------------------------------------------------------
	Name: Registering Vars
-----------------------------------------------------------]]
Impersonate.Net:RegisterGameVar("first_name", "string")
Impersonate.Net:RegisterGameVar("last_name", "string")
Impersonate.Net:RegisterGameVar("money", "number")
Impersonate.Net:RegisterGameVar("money_bank", "number")
Impersonate.Net:RegisterGameVar("sex", "string")
Impersonate.Net:RegisterGameVar("id", "number")
Impersonate.Net:RegisterGameVar("vehicles", "string")

-- lua_run Impersonate.Net:RegisterGameVar("money", "number")
-- lua_run Impersonate.Net:UpdateGameVar(Entity(1), "money", 10)
