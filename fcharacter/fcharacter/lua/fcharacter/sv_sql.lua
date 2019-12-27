--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local SQL = {}

SQL.PlayerInfo = FCharacter.SQL and FCharacter.SQL.PlayerInfo or {}

SQL.Config = {
	mysql =	FCharacter.Config.MySQL.UseMySQL,
	host = FCharacter.Config.MySQL.AUTH.host,
	username = FCharacter.Config.MySQL.AUTH.username,
	password = FCharacter.Config.MySQL.AUTH.password,
	schema =	FCharacter.Config.MySQL.AUTH.schema,
	port =	FCharacter.Config.MySQL.AUTH.port
}

SQL.DB = SQL.DB or FSQL(SQL.Config)

--[[---------------------------------------------------------
	Name: Database Functions
-----------------------------------------------------------]]
function SQL.Error(err, q)
  MsgC(Color(255, 120, 120), "[FCharacter SQL]: ", Color(255, 255, 255), "Error in querying ".. q.. ". \n", Color(255, 0, 0), "Error: ".. err.. " ", "\n")
end

function SQL.Initialize()
	FCharacter.Print("Connected to database.")

	local query = ""

  if SQL.DB:UsingMySQL() then
    query = [[
    CREATE TABLE IF NOT EXISTS `fcharacter_characters` (
      `id` INT NOT NULL AUTO_INCREMENT,
      `sid` VARCHAR(17) NOT NULL,
      `name` VARCHAR(45),
			`clone_id` VARCHAR(45),
      `job` VARCHAR(45) NOT NULL,
			`wallet` BIGINT NOT NULL,
      PRIMARY KEY (`id`)
    );
    ]]
  else
    query = [[
    CREATE TABLE IF NOT EXISTS `fcharacter_characters` (
      `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      `sid` VARCHAR(17) NOT NULL,
			`name` VARCHAR(45),
			`clone_id` VARCHAR(45),
      `job` VARCHAR(45) NOT NULL,
			`wallet` BIGINT NOT NULL
    );
    ]]
  end

  SQL.DB:Query(query, nil, SQL.Error)

	if SQL.DB:UsingMySQL() then
		query = [[
		CREATE TABLE IF NOT EXISTS `fcharacter_whitelist` (
      `sid` VARCHAR(17) NOT NULL,
      `jobs` TEXT NOT NULL,
			PRIMARY KEY (`sid`)
    );
		]]
	else
		query = [[
    CREATE TABLE IF NOT EXISTS `fcharacter_whitelist` (
      `sid` VARCHAR(17) NOT NULL PRIMARY KEY,
      `jobs` TEXT NOT NULL
    );
    ]]
	end

	SQL.DB:Query(query, nil, SQL.Error)
end

--[[---------------------------------------------------------
	Name: Character Functions
-----------------------------------------------------------]]
function SQL.GetCharacters(ply, callback)
  if not ply or not IsValid(ply) then return end
  callback = callback or function() end

  if SQL.PlayerInfo[ply:SteamID64()] then
    callback(true, SQL.PlayerInfo[ply:SteamID64()])
  end

  SQL.DB:Query([[SELECT * FROM `fcharacter_characters` WHERE sid = ]].. ply:SteamID64(), function(data)
    SQL.PlayerInfo[ply:SteamID64()] = data or {}

    callback(true, SQL.PlayerInfo[ply:SteamID64()])
  end, SQL.Error)
end

function SQL.UpdateCharacters(ply, callback)
  if not ply or not IsValid(ply) then return end
  callback = callback or function() end

	SQL.PlayerInfo[ply:SteamID64()] = {}

  SQL.DB:Query([[SELECT * FROM `fcharacter_characters` WHERE sid = ]].. ply:SteamID64(), function(data)
    SQL.PlayerInfo[ply:SteamID64()] = data or {}

    callback(true, SQL.PlayerInfo[ply:SteamID64()])
  end, SQL.Error)
end

function SQL.UpdateValue(char_id, key, value)
	SQL.DB:Query(string.format([[UPDATE `fcharacter_characters` SET %s = %s WHERE id = %s;]], key, value, char_id), nil, SQL.Error)
end

function SQL.CreateCharacter(ply, data, callback)
  if not ply or not IsValid(ply) then return end
  if ply.creating then return end

  callback = callback or function() end

  if not SQL.PlayerInfo[ply:SteamID64()] then
    SQL.GetCharacters(ply, function()
      SQL.CreateCharacter(ply, data, callback)
    end)

    return
  end

  if table.Count(SQL.PlayerInfo[ply:SteamID64()]) >= FCharacter.Config.MaxCharacters then
    callback(false, "Player reached maxed characters. (".. table.Count(SQL.PlayerInfo[ply:SteamID64()]).. ")")

    return
  end

	if #data.name > FCharacter.Config.MaxNameLength then

    data.name = string.sub(str, 1, FCharacter.Config.MaxNameLength)
  end

  ply.creating = true

  local query = string.format([[INSERT INTO `fcharacter_characters` (sid, name, clone_id, job, wallet) VALUES(%s, "%s", "%s", %s, %s)]],
	ply:SteamID64(), SQL.DB:Escape(data.name or "NULL"), SQL.DB:Escape(data.clone_id or "NULL"), data.job, data.wallet)

  SQL.DB:Query(query, function(...)
    if not SQL.PlayerInfo[ply:SteamID64()] then
      SQL.PlayerInfo[ply:SteamID64()] = {}
    end

    SQL.UpdateCharacters(ply, function()
			callback(true, SQL.PlayerInfo[ply:SteamID64()], table.insert(SQL.PlayerInfo[ply:SteamID64()], data) - 1)
			ply.creating = false
		end)
  end, SQL.Error)
end

function SQL.DeleteCharacter(ply, char_id)
	if not ply or not char_id then return end
	if not ply:GetCharacterByID(char_id) then return end

	SQL.DB:Query([[DELETE FROM `fcharacter_characters` WHERE id = ]].. char_id, function()
		if not ply then return end

		print("Success?")

		SQL.UpdateCharacters(ply, function()
			local characters = ply:GetCharacters()

	    characters = util.TableToJSON(characters)
	    characters = util.Compress(characters)

	    net.Start("FCharacter.RequestCharacters")
	      net.WriteUInt(#characters, 32)
	      net.WriteData(characters, #characters)
				net.WriteBool(true)
	    net.Send(ply)
		end)
	end)
end

function SQL.Disconnect(ply)
	if SQL.PlayerInfo[ply:SteamID64()] then
		SQL.PlayerInfo[ply:SteamID64()] = nil
	end
end hook.Add("PlayerDisconnected", "FCharacter.SQL.Disconnect", FCharacter.Disconnect)

function SQL.GetCloneID(callback)
	SQL.DB:Query([[SELECT * FROM `fcharacter_characters` WHERE clone_id != "NULL"]], function(data)
		local num = data and #data or 0

		callback(num)
	end)
end

function SQL.GetAllCharacters(callback)
	SQL.DB:Query([[SELECT * FROM `fcharacter_characters`]], function(data)
		if not data then
			if callback then callback({}) end
		end

		callback(data)
	end)
end

function SQL.GetCharacterByID(sid, callback)
	SQL.DB:Query([[SELECT * FROM `fcharacter_characters` WHERE sid = ]].. sid, function(data)
		if not data then
			if callback then callback({}) end
		end

		callback(data)
	end)
end

--[[---------------------------------------------------------
	Name: Whitelist Functions
-----------------------------------------------------------]]
function SQL.GetWhitelists(sid, callback)
	SQL.DB:Query([[SELECT * FROM `fcharacter_whitelist` WHERE sid = ]].. sid, function(data)
		if not data then
			callback({jobs = "[]", sid = sid})
			return
		end

		if callback then
			callback(data)
		end
	end)
end

function SQL.AddWhitelist(sid, job, callback)
	SQL.GetWhitelists(sid, function(jobs)
		jobs = jobs == {} and jobs or jobs[1] and util.JSONToTable(jobs[1].jobs) or jobs.jobs and util.JSONToTable(jobs.jobs) or nil

		if not jobs then
			jobs = {}

			jobs[job] = true

			SQL.DB:Query(string.format([[INSERT INTO `fcharacter_whitelist` (sid, jobs) VALUES(%s, '%s')]], sid, util.TableToJSON(jobs)), callback, SQL.Error)

			if callback then callback(jobs) end
			return
		end

		jobs[job] = true

		SQL.DB:Query(string.format([[UPDATE `fcharacter_whitelist` SET jobs = '%s' WHERE sid = %s]], util.TableToJSON(jobs), sid), callback, SQL.Error)

		if callback then callback(jobs) end
	end)
end

function SQL.RemoveWhitelist(sid, job, callback)
	SQL.GetWhitelists(sid, function(jobs)
		jobs = jobs == {} and jobs or jobs[1] and util.JSONToTable(jobs[1].jobs) or jobs.jobs and util.JSONToTable(jobs.jobs) or nil

		if not jobs then
			jobs = {}

			SQL.DB:Query(string.format([[INSERT INTO `fcharacter_whitelist` (sid, jobs) VALUES(%s, '%s')]], sid, util.TableToJSON(jobs)), callback, SQL.Error)


			if callback then
				callback(jobs)
			end
			return
		end

		jobs[job] = nil

		SQL.DB:Query(string.format([[UPDATE `fcharacter_whitelist` SET jobs = '%s' WHERE sid = %s]], util.TableToJSON(jobs), sid), callback, SQL.Error)

		if callback then
			callback(jobs)
		end
	end)
end

--[[---------------------------------------------------------
	Name: Main
-----------------------------------------------------------]]
if SQL.DB then
	SQL.DB:Disconnect()
end

SQL.DB.onConnected = SQL.Initialize

SQL.DB:Connect()

FCharacter.SQL = SQL
