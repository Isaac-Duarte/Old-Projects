--[[
	© 2019 Impersonate, do not share, re-distribute or modify

	without permission of its author (isaac.duarte@live.com)
]]
local file = file

local FILE_CLIENT = 0x0
local FILE_SHARED = 0x1
local FILE_SERVER = 0x2

local function AddCSInclude(sDirectory, sFilePattern, sFileType)
  files = file.Find(sDirectory.. "/".. sFilePattern, "LUA")

  for _, file in pairs(files) do
    local fileDir = sDirectory.. "/".. file

    if sFileType == FILE_SHARED then include(fileDir) end
    if sFileType == FILE_CLIENT and CLIENT then include(fileDir) end
    if sFileType == FILE_SERVER and SERVER then include(fileDir) end

    if sFileType == FILE_CLIENT and SERVER or sFileType == FILE_SHARED and SERVER then AddCSLuaFile(fileDir) end
  end
end

local function LoadAllTypes(sDirectory)
  AddCSInclude(sDirectory, "cl_*.lua", FILE_CLIENT)
  AddCSInclude(sDirectory, "sh_*.lua", FILE_SHARED)
  AddCSInclude(sDirectory, "sv_*.lua", FILE_SERVER)
end

local function LoadFolder(sFolder, tExcludeDir)
  tExcludeDir = tExcludeDir or {}

  LoadAllTypes(sFolder)

  local _, dirs = file.Find(sFolder.. "/*", "LUA")

  for _, dir in pairs(dirs) do
    if tExcludeDir[dir] then continue end

    LoadAllTypes(sFolder.. "/".. dir)
  end
end

function Impersonate._Core.LoadConfigs()
  LoadFolder(Impersonate.BaseDirectory.. "config")
end

function Impersonate._Core.LoadLibaries()
  LoadFolder(Impersonate.BaseDirectory.. "libraries")
end

function Impersonate._Core.LoadCore()
  LoadFolder(Impersonate.BaseDirectory.. "core", {boot = true})
  -- Impersonate.PrintSuccess("Loaded Core")
end

function Impersonate._Core.LoadModules()
  LoadFolder(Impersonate.BaseDirectory.. "modules")
  -- Impersonate.PrintSuccess("Loaded Modules")
end
