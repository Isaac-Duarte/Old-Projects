--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
FBM = FBM or {}
FBM.Sockets = FBM.Sockets or {}

--[[---------------------------------------------------------
  Name: Sockets
-----------------------------------------------------------]]
function FBM.SetupSockets()
  if not FBM.Sockets == {} then
    for k, v in pairs(FBM.Sockets) do
      if not IsValid(v) then continue end

      v:Remove()
    end

    FBM.Sockets = {}
  end

  if not FBM.CONFIG.Sockets[game.GetMap()] then return end
  if not FBM.CONFIG.PreSetPositions then return end

  for k, v in pairs(FBM.CONFIG.Sockets[game.GetMap()]) do
    local ent = ents.Create("fbm_socket")

    ent:SetPos(v.pos)
    ent:SetAngles(v.ang)
    ent:Spawn()

    local phys = ent:GetPhysicsObject()

    if IsValid(phys) then
      phys:EnableMotion(false)
    end

    table.insert(FBM.Sockets, ent)
  end
end

hook.Add("PlayerInitialSpawn", "FBM:Sockets", FBM.SetupSockets)

FBM.SetupSockets()

--[[---------------------------------------------------------
  Name: Net
-----------------------------------------------------------]]

--76561198412523868
net.Receive("FBM:ChangePowerState", function(len, ply)
  local ent = net.ReadEntity()
  local state = net.ReadBool() or false

  if ent:GetClass() != "fbm_miner" and ent:GetClass() != "fbm_hub" then return end
  if ply:GetPos():Distance(ent:GetPos()) > 100 then return end

  ent:ChangeIsMining(state)
end)

net.Receive("FBM:Sell", function(len, ply)
  local ent = net.ReadEntity()

  if not ent and not IsValid(ent) then return end

  if ent:GetClass() != "fbm_miner" and ent:GetClass() != "fbm_hub" then return end

  if ply:GetPos():Distance(ent:GetPos()) > 100 then return end

  local money = ent:GetBitcoin() * FBM.CONFIG.BCPrice

  FBM.AddMoney(ply, money)

  ent:SetBitcoin(0)
end)
