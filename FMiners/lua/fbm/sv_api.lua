---------------------------------
--  Realisitic Bitcoin Prices  --
--                             --
--  Made By Fozie              --
---------------------------------
FBM = FBM or {}

local link = "https://api.coindesk.com/v1/bpi/currentprice.json"

local update = 5 * 60

function FBM.UpdatePrice()
  if not FBM.CONFIG then return end
  if not FBM.CONFIG.RealBCPrice then timer.Remove("FBM:BitcoinPrices") return end

  http.Fetch(link, function(data)
    data = util.JSONToTable(data)

    if data == nil or data == {} then return end

    FBM.CONFIG.BCPrice = data.bpi["USD"]["rate_float"] or 0

    net.Start("FBM:UpdatePrice")
      net.WriteFloat(FBM.CONFIG.BCPrice)
    net.Broadcast()
  end)
end

timer.Create("FBM:BitcoinPrices", update, 0, FBM.UpdatePrice)

hook.Add("PlayerInitialSpawn", "FBM:InitalizePrices", function()
  timer.Simple(1, function()
    net.Start("FBM:UpdatePrice")
      net.WriteFloat(FBM.CONFIG.BCPrice)
    net.Broadcast()
  end)
end)

FBM.UpdatePrice()
