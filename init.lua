sumo_duels = {}

minetest.register_privilege("play", "Player can play.")
minetest.settings:set("static_spawnpoint", "0,100,0")

local mp = minetest.get_modpath(minetest.get_current_modname())

dofile(mp .. "/antibuildmine.lua")
dofile(mp .. "/kb.lua")
dofile(mp .. "/teams.lua")
dofile(mp .. "/void.lua")
dofile(mp .. "/hud.lua")
dofile(mp .. "/messages.lua")
