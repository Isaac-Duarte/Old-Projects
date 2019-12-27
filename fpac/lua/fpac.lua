--[[--------------------------------------------------------
	Name: Setup
----------------------------------------------------------]]
FPac = {
	_Version = 0x2,
  Author = "Fozie"
}

file.CreateDir("fpac")

--[[--------------------------------------------------------
	Name: Util
----------------------------------------------------------]]
local function ReadString(file)
	local str = ""
	local byte = file:ReadByte()

	while byte and byte != 0 do
		str = str.. string.char(byte)

		byte = file:ReadByte()
	end

	return str
end

--[[--------------------------------------------------------
	Name: Functions
----------------------------------------------------------]]
function FPac.GeneratePack(name, files)
  local file = file.Open("fpac/".. name.. ".dat", "wb", "DATA")
  if not file then return false end

  file:Write("FPac") -- Header of file.
  file:WriteUShort(FPac._Version) -- Version of FPac.
  file:Write(name) -- Name of Pack File.
  file:Write("\x00") -- Null Byte

  for k, v in pairs(files) do -- Let's add the files.
    file:Write(v.name) -- The name of the file.
		file:Write("\x00") -- Null Byte
  end

	file:Write("\x00") -- Null Byte

	for k, v in pairs(files) do -- Writing the contents
		file:Write(v.data) -- Writing the contents of the files.
    file:Write("\x00") -- Null Byte
	end

  file:Close()

  return true, "fpac/".. name.. ".dat"
end

function FPac.ReadFile(name)
  local file = file.Open("fpac/".. name.. ".dat", "rb", "DATA")
  if not file then return false end

  local header = file:Read(4) -- Header of file.
  if header != "FPac" then return false end

  local version = file:ReadUShort() -- Version of FPac.
  if not version == FPac._Version then return false end

  local pack_name = ReadString(file) -- Name of Pack File.

	local files = { -- Setup return table
		header = header,
		name = pack_name,
		version = version,
		files = {}
	}

	local t = true

  while t == true do -- Let's find out how many files are in this pack.
    local name = ReadString(file)

		files.files[name] = {
			data = "",
			name = name,
			CRC = 0
		}

		if file:Read(1) == "\x00" then -- Detect when there are two null bytes.
			t = false
		else
			file:Seek(file:Tell() - 1)
		end
	end

	for k, v in pairs(files.files) do -- Let's loop through these files
		local data = ReadString(file) -- Read the file.

		files.files[k].data = data -- Place in the data.
		files.files[k].CRC = util.CRC(data) -- Place in the CRC of the code.
	end

	return true, files
end
