# Import required modules.
import json
import os
import config

# Declaring dictionaries
Skins = {}
PlayerData = {}

# Local directory to the json data.
dir =  config.dir + "data/json"

# Called from main.py
def Initialize():
    # Create the file structure.
    if not os.path.exists(dir):
        os.mkdir(dir)
        os.mkdir(dir + "/player")

        # Write a blank JSON file
        file = open(dir + "/skins.json", "w")
        file.write("{}")
        file.close()

    #Read the current JSON data.
    file = open(dir + "/skins.json", "r")
    Skins = json.loads(file.read()) or {}
    file.close()

# This will make a change to the skins.json updating with the current table.
def UpdateSkins():
    file = open(dir + "/skins.json", "w")
    file.write(json.dumps(Skins))
    file.close()

# This will add a skin into the table and save it.
# @skin - Contains id, name, price, materials.
def AddSkin(skin):
    id = 1

    for k, v in Skins.items():
        if int(v["id"]) >= id:
            id = int(v["id"]) + 1

    Skins[id] = {
        "name": skin["name"],
        "price": skin["price"],
        "weapon": skin["weapon"],
        "materials": skin["materials"],
        "id": id
    }

    UpdateSkins()

    return id

# This will remove a skin and save it.
# @id - The ID of the skin.
def RemoveSkin(id):
    if id in Skins:
        del Skins[id]

    UpdateSkins()

def UpdatePlayerData(sid):
    # If the sid isn't registerd in the dictionary it'll put it in there.
    if not sid in PlayerData:
        InitializePlayer(sid)

    file = open(dir + "/player/" + str(sid) + ".json", "w")
    file.write(json.dumps(PlayerData[sid]))
    file.close()

# This will initialize a player's data file.
# @sid - The SteamID64 of a player.
def InitializePlayer(sid):
    sid = str(sid) or "_nil"
    data = {}

    # Retrieves the data from the player.
    if os.path.isfile(dir + "/player/" + str(sid) + ".json"):
        file = open(dir + "/player/" + str(sid) + ".json", "r")
        data = json.loads(file.read()) or {}
        file.close()
    else: # Initialize the player file if not loaded already.
        file = open(dir + "/player/" + str(sid) + ".json", "w")
        file.write("{}")
        file.close()

    # Places the data in the table.
    PlayerData[sid] = data

    return PlayerData[sid]

# This will add a skin to a players data file.
# @sid - The SteamID64 of a player.
# @skinid - The id of the skin.
def AddSkinToPlayer(sid, skinid):
    # Halt the function if the id isn't in the `Skin` table
    if not str(skinid) in Skins:
        return

    # If the sid isn't registerd in the dictionary it'll put it in there.
    if not sid in PlayerData:
        InitializePlayer(sid)

    # Haults the function if the player has the Skin.
    if str(skinid) in PlayerData[sid]:
        return

    PlayerData[sid][str(skinid)] = True
    UpdatePlayerData(sid)

# This will remove a skin from a players data file.
# @sid - The SteamID64 of a player.
# @skinid - The id of the skin.
def RemoveSkinFromPlayer(sid, skinid):
    # Halts the function if the id isn't in the `Skin` table
    if not str(skinid) in Skins:
        return

    # If the sid isn't registerd in the dictionary it'll put it in there.
    if not sid in PlayerData:
        InitializePlayer(sid)

    # Haults the function if the player doesn't have the Skin.
    if not str(skinid) in PlayerData[sid]:
        return

    PlayerData[sid].pop(str(skinid))
    UpdatePlayerData(sid)
