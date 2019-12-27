--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
ADDON_GLOBAL.Net = ADDON_GLOBAL.Net or {
  Protocalls = {
    _id = {}
  },
  Handlers = {}
}

if SERVER then
  util.AddNetworkString("ADDON_GLOBAL.Net")
end

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function ADDON_GLOBAL.Net.AddProtocol(name, id) -- Adds a protocal that can be used for networking
  if not name or not id then return end
  if ADDON_GLOBAL.Net.Protocalls[name] then return ADDON_GLOBAL.Net.Protocalls[name] end

  ADDON_GLOBAL.Net.Protocalls[name] = id
  ADDON_GLOBAL.Net.Protocalls._id[id] = name

  return name, id
end

function ADDON_GLOBAL.Net.GetIDByName(name) -- Get protocal ID via name
  return ADDON_GLOBAL.Net.Protocalls[name] or 0
end

function ADDON_GLOBAL.Net.GetNameByID(id) -- Get protocal name via ID
  return ADDON_GLOBAL.Net.Protocalls._id[id] or ""
end

function ADDON_GLOBAL.Net.IsValidProtocall(name) -- Returns if it's a valid protocal
  if not name then return false end

  if type(name) == "string" then
    return ADDON_GLOBAL.Net.Protocalls[name] or false
  elseif type(name) == "number" then
    return ADDON_GLOBAL.Net.Protocalls._id[name] or false
  end

  return false
end

function ADDON_GLOBAL.Net.StartEvent(name) -- Starts a event with the name
  if not name then return end

  if not ADDON_GLOBAL.Net.IsValidProtocall(name) then return end

  local id = ADDON_GLOBAL.Net.GetIDByName(name)

  net.Start("ADDON_GLOBAL.Net")
    net.WriteUInt(id, 8)
end

function ADDON_GLOBAL.Net.FireEvent(ply) -- Sends the event to a player
  if SERVER then
    net.Send(ply)
  elseif CLIENT then
    net.SendToServer()
  end
end

function ADDON_GLOBAL.Net.BroadcastEvent() -- Sends an event to everyone
  if SERVER then
    net.Broadcast()
  end
end

function ADDON_GLOBAL.Net.HandleEvent(name, func) -- Basically net.Receive
  if not func then return end
  if not ADDON_GLOBAL.Net.IsValidProtocall(name) then return end

  local id = ADDON_GLOBAL.Net.GetIDByName(name)

  ADDON_GLOBAL.Net.Handlers[name] = {
    id = id,
    func = func,
  }
end

function ADDON_GLOBAL.Net._HandleIncomingNet(len, ply) -- Make the addon work :) (No touchy)
  local id = net.ReadUInt(8)
  local name = ADDON_GLOBAL.Net.GetNameByID(id)

  if not ADDON_GLOBAL.Net.IsValidProtocall(id) then return end
  if not ADDON_GLOBAL.Net.Handlers[name] then return end
  
  ADDON_GLOBAL.Net.Handlers[name].func(len, ply)
end net.Receive("ADDON_GLOBAL.Net", ADDON_GLOBAL.Net._HandleIncomingNet)
