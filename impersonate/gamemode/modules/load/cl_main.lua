--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
Impersonate.Load = Impersonate.Load or {}
Impersonate.Load.CharacterSelected = Impersonate.Load.CharacterSelected or false

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Impersonate.Load:Initalize()
  if Impersonate.Load.CharacterSelected then return end

  if IsValid(Impersonate.Load.Menu) then
    Impersonate.Load.Menu:Close()
  end

  local menu = vgui.Create("Impersonate.ChooseCharacters")

  if not menu then
    timer.Simple(1, function()
      Impersonate.Load:Initalize()
    end)
    return
  end

  menu:SetSize(ScrW(), ScrH())
  menu:MakePopup()
  menu:SetDraggable(false)
  menu:SetTitle("")
  menu:ShowCloseButton(false)

  Impersonate.Load.Menu = menu
end hook.Add("Impersonate.SQL.ReceivedCharacters", "Impersonate.Load:Initalize", Impersonate.Load:Initalize())

function Impersonate.Load.SelectCharacter()
  local character = net.ReadFloat()

  Impersonate.Load.Menu:Remove()
  Impersonate.Load.CharacterSelected = true
  Impersonate.Load.Character = Impersonate.SQL._data.Characters[character]
  
end net.Receive("Impersonate.SQL.SelectCharacter", Impersonate.Load.SelectCharacter)
