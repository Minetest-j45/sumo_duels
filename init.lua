sumo_duels = {}

minetest.register_privilege("play", "Player can play.")

local mp = minetest.get_modpath(minetest.get_current_modname())

dofile(mp .. "/antibuildmine.lua")
dofile(mp .. "/kb.lua")
dofile(mp .. "/teams.lua")
