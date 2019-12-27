FSocket = {}

function FSocket.New()
  local self = setmetatable({}, FSocket)

  self.html = vgui.Create("DHTML" , frame)

  self.funcs = {
    open = {},
    close = {},
    message = {},
    err = {}
  }

  local function RunFunctions(tbl, data)
    if tbl == nil then return end

    for k, v in pairs(tbl) do
      v(data)
    end
  end

  self.html:AddFunction("fsock", "open", function()
      RunFunctions(self.funcs.open)
  end)

  self.html:AddFunction("fsock", "close", function()
      RunFunctions(self.funcs.close)
  end)

  self.html:AddFunction("fsock", "message", function(data)
      RunFunctions(self.funcs.message, data)
  end)

  self.html:AddFunction("fsock", "error", function(err)
    RunFunctions(self.funcs.err, err or "")
  end)

  self.html:SetHTML([[
  <script>
      function socket(url) {
          socket = new WebSocket(url);

          socket.onopen = function(){
              fsock.open();
          };

          socket.onclose = function(){
              fsock.close();
          };

          socket.onmessage = function(data){
              fsock.message(data.data);
          };

          socket.onerror = function(err){
              fsock.error(err);
          };

          window.socket = socket;
      }
  </script>
  ]])

  self.html:SetAllowLua(true)

  return self
end

function FSocket:Connect(url)
  self.url = url

	self.html:Call("socket(\"".. url.. "\")")
end

function FSocket:Send(data)
    self.html:Call([[
    if(window.socket){
      window.socket.send("]] .. data .. [[")
    }]])
end

function FSocket:Disconnect()
    self.html:Call([[
    if(window.socket){
      window.socket.close();
      window.socket = null;
    }]])
end

function FSocket:Destroy()
    if self.html then
      self:Disconnect()
      self.html:Remove()
      self.html = nil
      self = nil
    end
end

function FSocket:OnOpen(func)
  if not func then return end

  table.insert(self.funcs.open, func)
end

function FSocket:OnClose(func)
  if not func then return end

  table.insert(self.funcs.close, func)
end

function FSocket:OnReceive(func)
  if not func then return end

  table.insert(self.funcs.message, func)
end

function FSocket:OnError(func)
  if not func then return end

  table.insert(self.funcs.err, func)
end

function FSocket:__tostring()
  return "FSocket ".. (self.url and "Host: ".. self.url) or "Not Connected"
end

FSocket.__index = FSocket

setmetatable(FSocket, {
  __call = FSocket.New,
  __index = FSocket
})
