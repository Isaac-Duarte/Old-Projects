
--[[---------------------------------------------------------
	Name: Setup

  DISCLAIMER: Sorry for sloppy VGUI code. VGUI isn't my thing.
-----------------------------------------------------------]]
local PANEL = {}

surface.CreateFont("fbm.vgui:1", {
  font = "Default",
  size = 30,
  weight = 200,
})

surface.CreateFont("fbm.vgui:2", {
  font = "Arial",
  size = 20,
  weight = 600,
})

--[[---------------------------------------------------------
	Name: Panel
-----------------------------------------------------------]]
function PANEL:Init()
  self.ent = nil
  self.commands = {}

  self.close = vgui.Create("DButton", self)

  self.close.DoClick = function() self:Hide() end
  self.close.Paint = function(s, w, h)
    draw.SimpleText("X", "fbm.vgui:1", w / 2, h /2, Color(0, 0, 0), 1, 1)
  end

  self.full = vgui  .Create("DButton", self)

  self.full.DoClick = function()

  end
  self.full.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0))
    draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(255, 255, 255))
  end

  self.hide = vgui.Create("DButton", self)

  self.hide.DoClick = function()
    self:Hide()
  end
  self.hide.Paint = function(s, w, h)
    draw.RoundedBox(0, 0, h / 2, w, 1, Color(0, 0, 0))
  end

  self.text = vgui.Create("RichText", self)

  self:AddText("Welcome to the FMiner terminal!\nTo get a list of commands type 'help' in the command line.")

  self.input = vgui.Create("DTextEntry", self)

  self.input.Paint = function() end

  self.input.OnChange = function(s)
    self.curcommand = s:GetText() or ""
  end

  self.input.Think = function(s)
    s:RequestFocus()
  end

  self.input.OnEnter = function(s)

    self:AddUserComamnd(s:GetText())
    self:ProccessComamand(s:GetText())

    self.curcommand = ""
    s:SetText("")
  end

  self.curcommand = ""

  self.commands["help"] = function()
    local text = ""

    text = text.. "-'help' This will display all the console commands."
    text = text.. "\n".. "-'clear' This will clear the console."
    text = text.. "\n".. "-'info' This will display the information of the bitcoin miner."
    text = text.. "\n".. "-'mining start' This will attempt to start bitcoin mining."
    text = text.. "\n".. "-'mining stop' This will attempt to stop bitcoin mining."
    text = text.. "\n".. "-'sell' This will sell the current bitcoin(s) you have."

    self:AddText(text)
  end

  self.commands["clear"] = function()
    self.text:SetText("")
    self:AddText("Welcome to the FMiner terminal!\nTo get a list of commands type 'help' in the command line.")
  end

  self.commands["fozie"] = function()
    self:AddText("Hello, you found the secret command!")
    self:AddText("There's really nothing special for this command.")
    self:AddText("I mean, you could add me on Discord or Steam if you want.")
    self:AddText("Who knows, maybe I'll give you something.")
    self:AddText("Discord: Fozie#5014")
    self:AddText("Steam: http://steamcommunity.com/profiles/76561198412523868")
  end

end

function PANEL:Paint(w, h)
  draw.RoundedBoxEx(5, 0, 0, w, h, Color(202, 99, 75), true, true, false, false)
  draw.RoundedBoxEx(5, 1, 1, w - 2, h - 2, Color(48, 10, 36), true, true, false, false)
  draw.RoundedBoxEx(5, 1, 1, w - 2, 30, Color(255, 255, 255), true, true, false, false)

  draw.SimpleText("root@FMiner:~", "fbm.vgui:2", 5, 15, Color(0, 0, 0), 0, 1)
  draw.SimpleText("root@FMiner:~", "fbm.vgui:2", 5, h - 15, Color(140, 230, 52), 0, 1)

  surface.SetFont("fbm.vgui:2")
  local w2, h2 = surface.GetTextSize("root@FMiner:~")

  draw.SimpleText(self.curcommand, "fbm.vgui:2", 5 + w2 + 10, h - 15, Color(255, 255, 255), 0, 1)
end

function PANEL:PerformLayout(w, h)
  self:ShowCloseButton(false)
  self:SetTitle("")

  self.close:SetSize(16, 16)
  self.close:AlignTop(8)
  self.close:AlignRight(6)
  self.close:SetText("")

  self.full:SetSize(16, 16)
  self.full:AlignTop(8)
  self.full:AlignRight(6 + (16 * 1) + 16)
  self.full:SetText("")

  self.hide:SetSize(16, 16)
  self.hide:AlignTop(8)
  self.hide:AlignRight(6 + (16 * 3) + 20)
  self.hide:SetText("")

  self.text:SetSize(w - 2, h - 32 - 30)
  self.text:SetPos(2, 32)
  self.text:SetFontInternal("fbm.vgui:2")

  surface.SetFont("fbm.vgui:2")
  local w2, h2 = surface.GetTextSize("root@FMiner:~")

  self.input:SetPos(w2, h - 30)
  self.input:SetSize(w - w2, 30)
end

function PANEL:SetEnt(ent)
  if ent:GetClass() != "fbm_miner" and ent:GetClass() != "fbm_hub" then return end

  self.ent = ent

  self.commands["info"] = function()
    if ent:GetClass() == "fbm_hub" then
      self:AddText("Amount of ASCI Miners: ".. self.ent:GetSticks())
    end

    self:AddText("Has Power: ".. tostring(self.ent:GetHasPower()))
    self:AddText("Mining: ".. tostring(self.ent:GetIsActivated()))
    self:AddText("Bitcoin Amount: ".. self.ent:GetBitcoin())
    self:AddText("Produced Bitcoin Value: $".. math.Round(self.ent:GetBitcoin() * FBM.CONFIG.BCPrice, 2))
  end

  self.commands["mining start"] = function()
    if self.ent:GetIsActivated() then
      self:AddText("The bitcoin miner is already running.")

      return
    end

    self:AddText("Attemping to start bitcoin mining.")

    net.Start("FBM:ChangePowerState")
      net.WriteEntity(self.ent)
      net.WriteBool(true)
    net.SendToServer()
  end

  self.commands["mining stop"] = function()
    if self.ent:GetIsActivated() == false then
      self:AddText("The bitcoin miner isn't started yet.")

      return
    end

    self:AddText("Attemping to stop bitcoin mining.")

    net.Start("FBM:ChangePowerState")
      net.WriteEntity(self.ent)
      net.WriteBool(false)
    net.SendToServer()
  end

  self.commands["sell"] = function()
    self:AddText("Congratulations you made: $".. math.Round(self.ent:GetBitcoin() * FBM.CONFIG.BCPrice, 2).. "!")

    net.Start("FBM:Sell")
      net.WriteEntity(self.ent)
    net.SendToServer()
  end
end

function PANEL:AddUserComamnd(text, color)
  if text == "" then return end

  self.text:InsertColorChange(140, 230, 52, 255)
  self.text:AppendText("\nroot@FMiner:~ ")

  color = color or Color(255, 255, 255, 255)

  self.text:InsertColorChange(color.r, color.g, color.b, color.a)
  self.text:AppendText(text)
end

function PANEL:AddText(text, color)
  color = color or Color(255, 255, 255, 255)

  self.text:InsertColorChange(color.r, color.g, color.b, color.a)
  self.text:AppendText("\n".. text)
end

function PANEL:ProccessComamand(cmd)
  cmd = string.lower(cmd)

  if cmd == "" then return end

  local multi = string.Explode("; ", cmd)

  for k, v in pairs(multi) do
    if not self.commands[v] then

      self:AddText("Sorry, but that's an unknown command!")
      return
    end

    self.commands[v]()
  end
end

vgui.Register("FBM:Frame", PANEL, "DFrame")

--[[---------------------------------------------------------
	Name: Net
-----------------------------------------------------------]]
net.Receive("FBM:OpenMenu", function()
  local ent = net.ReadEntity()

  if ent:GetClass() != "fbm_miner" and ent:GetClass() != "fbm_hub" then return end

  if not ent.frame then
    ent.frame = vgui.Create("FBM:Frame")

    ent.frame:SetSize(ScrW() * 0.35, ScrH() * 0.35)
    ent.frame:Center()
    ent.frame:SetEnt(ent)

    ent.frame:MakePopup()

    return
  end

  ent.frame:Show()
end)
