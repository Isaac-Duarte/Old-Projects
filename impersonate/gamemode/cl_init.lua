include("shared.lua")


function GM:OnReloaded()
  if not Impersonate.Config.AUTO_REFRESH then return end

  self:Initalize()
end

function GM:Initalize()
  Impersonate.Jobs:LoadJobs()
  Impersonate.Load:Initalize()
end
