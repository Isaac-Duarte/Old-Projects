# Wack Net
This is just a basic way to have networking in one network string.

**Replace ADDON_GLOBAL with whatever global table you have for your addon. (or localize it)**

### Example

```lua
include("sh_net.lua") -- Include the networking file.

ADDON_GLOBAL.Net.AddProtocol("print", 0x1) -- AddProtocol(name, unique_id)

if SERVER then
	concommand.Add("send_to_client", function(ply)
		ADDON_GLOBAL.Net.StartEvent("print") -- StartEvent(name)
			net.WriteString("Hey, just letting you know that you're really gay!")
		ADDON_GLOBAL.Net.BroadcastEvent() -- Sends it to everyonnne
	end)
end

if CLIENT then
	ADDON_GLOBAL.Net.HandleEvent("print", function(len) -- Hey we got a message. HandleEvent(name, callback)
		local msg = net.ReadString()

		chat.AddText(msg, " :(")
	end)
end
```
