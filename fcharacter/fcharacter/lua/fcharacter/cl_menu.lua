--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local Menu = {}

Menu.Menu = FCharacter.Menu and FCharacter.Menu.Menu or nil

Menu.Wait = false

local function phrase(...)
  return FCharacter.Lang.GetPhrase(...)
end

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Menu.Open()
  if not FCharacter.Ply.Character and IsValid(Menu.Menu) then return end

  if IsValid(Menu.Menu) then
    Menu.Menu:Remove()

    return
  end

  Menu.Menu = vgui.Create("FCharacter.Frame")

  Menu.Menu:SetSize(ScrW(), ScrH())
  Menu.Menu:Center()
  Menu.Menu:MakePopup()
end

local down = false
local wait = false
local moved = false

local time = CurTime()

function Menu.KeyPress(ply, move)
  if not moved and wait and move:GetVelocity():Length() > 0 then
    moved = true

    chat.AddText(phrase("moved"))
  end

  if input.WasKeyReleased(KEY_F6) and not down and not Menu.Wait then
    wait = true
    down = true

    time = CurTime()

    chat.AddText(string.format(phrase("wait"), FCharacter.Config.Wait))

    timer.Simple(FCharacter.Config.Wait, function()
      if not moved then Menu.Open() end

      wait = false
      moved = false
    end)
  elseif not wait then
    down = false
  end
end hook.Add("Move", "FCharacter.Menu.Keypress", Menu.KeyPress)

function Menu.Paint()
  if wait and not moved then
    draw.SimpleTextOutlined(string.format(phrase("wait"), math.Round(((time + FCharacter.Config.Wait) - CurTime()))), "fc_2", ScrW() / 2, ScrH() / 2, Color(255, 232, 31), 1, 1, 2, Color(0, 0, 0))
  elseif wait and moved then
    draw.SimpleTextOutlined(phrase("moved"), "fc_2", ScrW() / 2, ScrH() / 2, Color(255, 0, 0), 1, 1, 2, Color(0, 0, 0))
  end

end hook.Add("HUDPaint", "FCharacter.Menu.Paint", Menu.Paint)

--[[---------------------------------------------------------
	Name: Admin Menu
-----------------------------------------------------------]]
function Menu.OpenAdminMenu()
  if not FCharacter.Config.AdminMenu[LocalPlayer():GetUserGroup()] then return end

  if IsValid(Menu.Admin) then
    return
  end

  Menu.Admin = vgui.Create("FCharacter.Admin")

  Menu.Admin:SetSize(800, 600)
	Menu.Admin:Center()
	Menu.Admin:MakePopup()
end

if FCharacter.Config.AdminMenu[LocalPlayer():GetUserGroup()] then
  concommand.Add("fcharacter_admin", function()
    Menu.OpenAdminMenu()
  end)
end

--[[---------------------------------------------------------
	Name: Main
-----------------------------------------------------------]]
timer.Simple(0, function()
  Menu.Open()
end)

FCharacter.Menu = Menu
