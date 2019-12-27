# FSocket

FSocket is a way to connect to a web socket and receive/send packets to a server.

## How it works

The web socket function creates a web socket via JavaScript through DHTML.

## Examples

#### Lua
```lua
--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
if not pcall(include, "fsocket.lua") then
  Error("You need to have the socket lib installed in order for this to work!")
end

if socket and socket:GetState() == 1 then
  socket:Disconnect()
else
  socket = FSocket()
end

socket:Connect("ws://127.0.0.1:6789")

--[[---------------------------------------------------------
	Name: Main
-----------------------------------------------------------]]
socket:OnOpen(function()
	print("Socket Connected to server.")

	socket:Send("Hello, I'm a client.")
end)

socket:OnReceive(function(data)
	print("Received: ".. data)
end)

socket:OnClose(function()
	print("Socket Closed")
end)

socket:OnError(function(err)
	print("Error: ".. err)
end)
```
#### NodeJS

```js
const WebSocket = require("ws");

const server = new WebSocket.Server({
  port:6789
});

server.on("connection", function connection(ws) {
  ws.on("message", function incoming(message) {
    console.log("received: %s", message);
  });

  ws.send("Yeet");
});
```
