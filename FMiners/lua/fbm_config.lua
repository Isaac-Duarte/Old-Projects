--[[---------------------------------------------------------
	Name: Main
-----------------------------------------------------------]]
// DO NOT TOUCH
FBM = FBM or {}

// DO NOT TOUCH
FBM.CONFIG = {}

FBM.CONFIG.Sockets = {} // DO NOT TOUCH

// The amount that 1 bitcoin sells for. WILL NOT WORK IF 'FBM.CONFIG.RealBCPrice' is set to true!
FBM.CONFIG.BCPrice = 6120

// Allows automatic updates to the bitcoin price based off of real life.
FBM.CONFIG.RealBCPrice = true

// This is the rate that bitcoin miners will mine at.
FBM.CONFIG.Rate = 0.0001

// This is the rate that ASIC Stick Mineres will mine at.
FBM.CONFIG.StickRate = 0.00001

// This is the currency symbol for certain texts.
FBM.CONFIG.CurrencySymbol = "$"

// The command to save the sockets in the map.
FBM.CONFIG.Save = "/save_sockets"

// Determains which usergroup is allowed to use the command.
FBM.CONFIG.Allowed = {
  "superadmin",
}

// Overrides the usergrup configuration to do a check to see if they're superadmin or not.
FBM.CONFIG.Superadmin = false

--[[---------------------------------------------------------
  Name: DarkRP Config
-----------------------------------------------------------]]
// DO NOT TOUCH
FBM.CONFIG.DARKRP = {}

// This will determain weather the bitcoin miners will be added to the F4 menu or not.
FBM.CONFIG.DARKRP.Add = true

// This will be the price of the bitcoin miner.
FBM.CONFIG.DARKRP.BitcoinMinerPrice = 15000

// This will be how many a user can buy
FBM.CONFIG.DARKRP.BitcoinMinerMax = 4

// This will be the price of the Extention Lead
FBM.CONFIG.DARKRP.ExtentionLeadPrice = 100

// This will be how many a user can buy
FBM.CONFIG.DARKRP.ExtentionLeadMax = 2

// This will be the price of the Bitcoin Monitor
FBM.CONFIG.DARKRP.BitcoinMonitorPrice = 1000

// This will be how many a user can buy
FBM.CONFIG.DARKRP.BitcoinMonitorMax = 1

// This will be the price of the Bitcoin Monitor
FBM.CONFIG.DARKRP.ACSIPrice = 200

// This will be how many a user can buy
FBM.CONFIG.DARKRP.ACSIMax = 40

// This will be the price of the Bitcoin Monitor
FBM.CONFIG.DARKRP.ACSIHubPrice = 500

// This will be how many a user can buy
FBM.CONFIG.DARKRP.ACSIHubMax = 2
--[[---------------------------------------------------------
  Name: Map
-----------------------------------------------------------]]
// This will determain if sockets will spawn using the config below.
// Using PermaProp works also!
// Using the command works too. :)
FBM.CONFIG.PreSetPositions = false

// Location where the sockets are.

--[[
  To use this feature uncomment the code from below. You could eaither use /save_sockets instead.
]]--

--[[
FBM.CONFIG.Sockets["rp_downtown_v4c_v2"] = {
  {
    pos = Vector(2130, -1351, -175),
    ang = Angle(0, -180, 180),
  },
}
]]--

--[[---------------------------------------------------------
	Name: Functions

  DONT touch below here unless you know what you're doing.
-----------------------------------------------------------]]

function FBM.AddMoney(ply, amount)
  ply:addMoney(amount)
end
