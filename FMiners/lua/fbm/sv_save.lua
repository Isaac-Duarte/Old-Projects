--[[---------------------------------------------------------
  Name: Sockets
-----------------------------------------------------------]]
FBM = FBM or {}
FBM.Sockets = FBM.Sockets or {}


function FBM.SavePositions() // Looks for all the sockets in the map and saves them to a file.
  local map = game.GetMap()

  file.CreateDir("fminers")
  file.CreateDir("fminers/".. map)

  if not file.Exists("fminers/".. map.. "/positions.txt", "DATA") then
    file.Write("fminers/".. map.. "/positions.txt", "[]")
  end

  local data = {}

  for k, v in pairs(ents.FindByClass("fbm_socket")) do
    local tbl = {
      pos = v:GetPos(),
      ang = v:GetAngles()
    }

    table.insert(data, tbl)
  end

  file.Write("fminers/".. map.. "/positions.txt", util.TableToJSON(data, true))
end

function FBM.SpawnSockets() // Spawns all of the sockets if found in the data folder.
    local map = game.GetMap()

  for k, v in pairs(ents.FindByClass("fbm_socket")) do
    v:Remove()
  end

  file.CreateDir("fminers")
  file.CreateDir("fminers/".. map)

  if not file.Exists("fminers/".. map.. "/positions.txt", "DATA") then
    file.Write("fminers/".. map.. "/positions.txt", "[]")
  end

  local data = util.JSONToTable(file.Read("fminers/".. map.. "/positions.txt", "DATA"))

  for k, v in pairs(data) do
    local ent = ents.Create("fbm_socket")

    ent:SetPos(v.pos)
    ent:SetAngles(v.ang)

    ent:Spawn()

    local phys = ent:GetPhysicsObject()

    if phys then
      phys:EnableMotion(false)
    end
  end
end

function FBM.Allowed(ply) // Returns weather a user has permission to use the command
  if not FBM.CONFIG.Superadmin then
    return table.HasValue(FBM.CONFIG.Allowed, ply:GetUserGroup())
  end

  return ply:IsSuperAdmin()
end

function FBM.HandleChat(ply, text) // Adds in the command /save_sockets
  if not FBM.Allowed(ply) then return end

  local ex = string.Explode(" ", text)

  if string.lower(ex[1]) == FBM.CONFIG.Save then
    FBM.SavePositions()
    FBM.SpawnSockets()

    ply:ChatPrint("[FMiners]: Saved the socket positions.")

    return ""
  end
end

hook.Add("PlayerSay", "FBM.SavePositions", FBM.HandleChat)
hook.Add("InitPostEntity", "FBM.SpawnSockets", FBM.SpawnSockets)
hook.Add("PostCleanupMap", "FBM.SpawnSockets", FBM.SpawnSockets)
