--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
FSQL = {}

--[[---------------------------------------------------------
  Name: Functions
-----------------------------------------------------------]]
function FSQL.Constructor(self, config)
  local sql = {}

  config = config or {}

  sql.config = {
    mysql = config.mysql or false,
    host = config.host or "",
    username = config.username or "",
    password = config.password or "",
    schema = config.schema or "",
    port = config.port or 3306
  }

  sql.onConnected = function() end
  sql.cache = {}

  setmetatable(sql, FSQL)

  sql:RequireModule()

  return sql
end

local function querymysql(self, query, callback, errorCallback)
  if not query or not self.db then return end

  local q = self.db:query(query)

  function q:onSuccess(data)
    if callback then
      callback(data)
    end
  end

  function q:onError(_, err)
    if not self.db or self.db:status() == mysqlOO.DATABASE_NOT_CONNECTED then
      table.insert(self.cache, {
        query = query,
        callback = callback,
        errorCallback = errorCallback
      })

      self:Connect(self.config.host, self.config.username, self.config.password, self.config.schema, self.config.port)

      return
    end

    if errorCallback then
      errorCallback(err)
    end
  end

  q:start()
end

local function querySQLite(self, query, callback, errorCallback)
  if not query then return end

  sql.m_strError = ""

  local lastError = sql.LastError()
  local result = sql.Query(query)

  if sql.LastError() and sql.LastError() != lastError then
      local err = sql.LastError()

      if errorCallback then
        errorCallback(err, query)
      end

      return
  end

  if callback then
    callback(result)
  end
end

--[[---------------------------------------------------------
	Name: Meta Function
-----------------------------------------------------------]]
function FSQL:RequireModule()
  if not self.config.mysql then return end

  if not pcall(require, "mysqloo") then
    error("Couldn't find mysqlOO. Please install https://github.com/FredyH/mysqlOO. Reverting to SQLite")

    self.config.mysql = false
  end
end

function FSQL:SetConfig(config)
  if not config or not type(config) == "table" then return end

  self:RequireModule()

  self.config = config
end

function FSQL:Connect()
  if self.config.mysql then
    self.db = mysqloo.connect(self.config.host, self.config.username, self.config.password, self.config.schema, self.config.port)

    self.db.onConnectionFailed = function(_, msg)
        timer.Simple(5, function()
          if not self then return end

          self:Connect(self.config.host, self.config.username, self.config.password, self.config.schema, self.config.port)
        end)

        error("Connection failed! " .. tostring(msg) ..  "\nTrying again in 5 seconds.")
    end

    self.db.onConnected = function()
      for k, v in pairs(self.cache or {}) do
        self:Query(v.query, v.callback, v.errorCallback)
      end

      self.cache = {}

      self.onConnected()
    end

    self.db:connect()
  else
    self.onConnected()
  end
end

function FSQL:Disconnect()
  if IsValid(self.db) then
    self.db:disconnect()
  end
end

function FSQL:Query(query, callback, errorCallback)
  local func = self.config.mysql and querymysql or querySQLite

  func(self, query, callback, errorCallback)
end

function FSQL:UsingMySQL()
  return self.config.mysql
end

function FSQL:Escape(str)
  if self:UsingMySQL() then
    return  string.Replace(self.db:escape(tostring(str)), "'", "")
  else
    return string.Replace(sql.SQLStr(str), "'", "")
  end
end

--[[---------------------------------------------------------
	Name: Meta Tables
-----------------------------------------------------------]]
FSQL.__index = FSQL

setmetatable(FSQL, {
  __call = FSQL.Constructor
})
