--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
FBM = FBM or {}

FBM.CONFIG = FBM.CONFIG or {}

--[[---------------------------------------------------------
	Name: Main
-----------------------------------------------------------]]

function FBM.AddDarkRP() // Addds all the entities to the F4 menu.
  if not FBM.CONFIG.DARKRP.Add then return end

  DarkRP.createCategory{
		name = "FMiners",
		categorises = "entities",
		startExpanded = true,
		color = Color(0, 119, 255, 255),
		sortOrder = 1,
	}

	DarkRP.createEntity("Bitcoin Miner", {
		ent = "fbm_miner",
		model = "models/livinrp/catminer_s9.mdl",
		price = FBM.CONFIG.DARKRP.BitcoinMinerPrice,
		max = FBM.CONFIG.DARKRP.BitcoinMinerMax,
		category = "FMiners",
		cmd = "buybitcoinminer"
	})

  DarkRP.createEntity("Extention Lead", {
		ent = "fbm_extention",
		model = "models/livinrp/plug_extension.mdl",
		price = FBM.CONFIG.DARKRP.ExtentionLeadPrice,
		max = FBM.CONFIG.DARKRP.ExtentionLeadMax,
		category = "FMiners",
		cmd = "buyextentionlead"
	})

  DarkRP.createEntity("ACSI Miner", {
		ent = "fbm_asic",
		model = "models/nicksmodels/asic_miner.mdl",
		price = FBM.CONFIG.DARKRP.ACSIPrice,
		max = FBM.CONFIG.DARKRP.ACSIMax,
		category = "FMiners",
		cmd = "buyacsiminer"
	})

  DarkRP.createEntity("USB Hub", {
		ent = "fbm_hub",
		model = "models/bitminer/usb_hub.mdl",
		price = FBM.CONFIG.DARKRP.ACSIHubPrice,
		max = FBM.CONFIG.DARKRP.ACSIHubMax,
		category = "FMiners",
		cmd = "buyusbhub"
	})
end

hook.Add("DarkRPFinishedLoading", "FBM.AddDarkRP", FBM.AddDarkRP)
