# FCharacter

Character system for Menschlich.

### Adding Languages

1) Create a new file in fcharacter/lua/fcharacter/languages/*filename*.lua

2) Change the language code

3) Modify all of the phrases
```lua
--[[---------------------------------------------------------
	Name: Setup
-----------------------------------------------------------]]
local Lang = {}

Lang.code = "de"

Lang.phrases = {
  ...
}

FCharacter.Lang.AddLang(Lang)
```


### Developer Info

**Hooks**

```lua
hook.Run("FCharacter.LangLoaded")
-- Called when languages are loaded.

hook.Run("FCharacter.Loaded")
-- Called when addon is loaded.

hook.Run("FCharacter.CanJoinCharacter", pPlayer, tCharacter)
-- Called when a player attempts to join a character.
-- If return false the player won't be able to join that character.

hook.Run("FCharacter.CharacterSelected", pPlayer, tCharacter)
-- Called when a player selects a character.
```

**Functions**

```lua
FCharacter.Lang.GetCurrentLanguage()
-- Returns current language selected. *shared*
```
