--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
require("mysqloo")

Impersonate.SQL = Impersonate.SQL or {}
Impersonate.SQL.db = Impersonate.SQL.db or mysqloo.connect(Impersonate.Config.MySQL.AUTH.host, Impersonate.Config.MySQL.AUTH.username, Impersonate.Config.MySQL.AUTH.password, Impersonate.Config.MySQL.AUTH.schema, Impersonate.Config.MySQL.AUTH.port)
Impersonate.SQL.Connected = Impersonate.SQL.Connected or false

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Impersonate.SQL:Initalize()
  function self.db:onConnected()
    Impersonate.DebugPrint("MySQL", "Successfully connected to MySQL Databse. (".. Impersonate.Config.MySQL.AUTH.host.. ")")
    Impersonate.SQL.Connected = true

    hook.Run("Impersonate.SQL.Connected")

    Impersonate.SQL:Query([[
    CREATE TABLE `characters` (
      `steamid64` VARCHAR(45) NOT NULL DEFAULT '00000000000',
      `id` INT NOT NULL,
      `first_name` VARCHAR(45) NOT NULL DEFAULT 'John',
      `last_name` VARCHAR(45) NOT NULL DEFAULT 'Doe',
      `sex` VARCHAR(45) NOT NULL DEFAULT 'male',
      `model` VARCHAR(45) NULL DEFAULT NULL,
      `model_override` VARCHAR(45) NULL DEFAULT NULL,
      `skin` INT NOT NULL DEFAULT 0,
      `body_groups` LONGTEXT NOT NULL,
      `money` VARCHAR(45) NOT NULL DEFAULT '500',
      `money_bank` VARCHAR(45) NOT NULL DEFAULT '1000',
      `physical_state` LONGTEXT NOT NULL,
      `vehicles` LONGTEXT NOT NULL,
      PRIMARY KEY (`steamid64`, `id`)
    );
    ]], function(succ, result)
      if succ then
        Impersonate.DebugPrint("MySQL", "Made `characters` table.")
      else
        -- Impersonate.DebugPrint("MySQL", "Error while trying to create `characters` table. (Usually need to ignore this error) \nError: ".. result)
      end
    end)
  end

  function self.db:onConnectionFailed(err)
    Impersonate.PrintError("MySQL", "Couldn't connect to MySQL Databse! Retrying in 10 seconeds ERROR: ".. err)

    Impersonate.SQL.Connected = false
    self:disconnect()

    timer.Simple(10, function()
      Impersonate.SQL:Initalize()
    end)
  end

  if Impersonate.SQL.Connected then
    Impersonate.DebugPrint("MySQL", "Found exsisting connection.")

    Impersonate.SQL.Connected = true

    self.db:onConnected()
    return
  end

  Impersonate.SQL.Connected = true
end

function Impersonate.SQL:Query(query, callback)
  -- if not Impersonate.SQL.Connected then return end

  local q = self.db:query(query)

  function q:onSuccess(data)
    callback(true, data)
  end

  function q:onError(err, sql)
    callback(false, err)
  end

  q:start()
end

if not Impersonate.SQL.Connected then
  Impersonate.SQL.db:connect()
  Impersonate.SQL.Connected = true
end
