ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Bitcoin Miner"
ENT.Spawnable = true
ENT.Category = "Fozie's Bitminers"

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsActivated")
    self:NetworkVar("Bool", 1, "HasPower")

    self:NetworkVar("Float", 0, "Bitcoin")

    self:NetworkVar("Entity", 0, "owning_ent")
end

function ENT:Initialize()
    self:SetIsActivated(false)
    self:SetHasPower(false)
    self:SetBitcoin(0)
end
