# Import required modules.
from gmod.lua import *
from gmod.luanamespace import *
import os
import config

# Create the folder structure.
if not os.path.exists(config.dir + "data"):
    os.mkdir(config.dir + "data")

# Data saving provider, currently only three available.
# _json, _sql, or _mysql
from providers import _sql as save

save.Initialize()
