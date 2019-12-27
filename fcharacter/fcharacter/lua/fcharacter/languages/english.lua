--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local Lang = {}

Lang.code = "en"

Lang.phrases = {
  ["title_top"] = "Cube",
  ["title_bottom"] = "Generation",
  ["tos"] = "You are responsible for any rules you break",
  ["disconnect"] = "Disconnect",

  ["character_top"] = "Create",
  ["character_bottom"] = "Character",
  ["clone_id"] = "Clone id",
  ["name"] = "Name",
  ["job"] = "Jobs",
  ["model"] = "Appearance",
  ["return"] = "Back",
  ["create"] = "Create",
  ["delete_title"] = "Delete %s",
  ["delete_text"] = "Do you really want to delete %s?",
  ["delete_accept"] = "Yes",
  ["delete_deny"] = "No",

  ["whitelist_fail"] = "You can't join that job, you must be whitelisted!",

  ["wait"] = "Please stay still for %s seconds.",
  ["changing"] = "You're already changing characters.",
  ["moved"] = "Cancled due to movement."
}

FCharacter.Lang.AddLang(Lang)
