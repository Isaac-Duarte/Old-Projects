# FSQL
Simple object oriented SQL.

This is to make using SQLite and MySQL easier.

*going to add more!*

**Example**
```lua
local config = {
	mysql =	false,
	host = "xxxx",
	username = "xxxx",
	password = "xxxx",
	schema = "xxxx",
	port =	3306
}

db = db or FSQL(SQL.Config)

db.onConnected = function()
  print("MySQL set to ": db:UsingMySQL())

  local auto = db:UsingMySQL() and "AUTO_INCREMENT" or "AUTOINCREMENT"

  db:Query([[CREATE TABLE IF NOT EXISTS `fozie` (
      `id` INT NOT NULL ]].. auto.. [[,
      `name` VARCHAR(45),
      PRIMARY KEY (`id`)
    );]], function()
      print("Yeet created the table.")
    end, function(err)
      print("You suck at coding btw. \n".. err)
    end)
end

db:Connect()

--[[
You can also call self if you write the function like this.

function db:onConnected()
  print(self:UsingMySQL())
end
]]
```
