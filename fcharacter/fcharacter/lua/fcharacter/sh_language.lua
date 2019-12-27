--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local Lang = {}
Lang.Langs = {}

--[[---------------------------------------------------------
	Name: Functions
-----------------------------------------------------------]]
function Lang.Initalize()
  Lang.LoadLangs()
end

function Lang.GetDirectory()
  local dir = debug.getinfo(1, "S").short_src

  dir = string.Split(dir, "lua/")[2]
  dir = string.GetPathFromFilename(dir)

  return dir
end

function Lang.LoadLangs()
  local dir = Lang.GetDirectory().. "languages/"

  local langs = file.Find(dir.. "*", "LUA")

  for k, v in pairs(langs) do
    include(dir.. v)
    AddCSLuaFile(dir.. v)
  end
end

function Lang.AddLang(table)
  Lang.Langs[table.code] = table.phrases
end

function Lang.GetPhrase(typ)
  return Lang.Langs[FCharacter.Config.Language] and (Lang.Langs[FCharacter.Config.Language][typ] or "nil") or "nil"
end

function Lang.GetCurrentLanguage()
  return FCharacter.Config.Language
end

FCharacter.Lang = Lang

Lang.Initalize()
