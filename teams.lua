sumo_deuls.teams = {lobby = {}, waiting_arena_1 = {}, arena_1 = {}}

local sumo_deuls.before = {}

sumo_deuls.get_player_team = function(name)
	for k, team in pairs(sumo_deuls.teams) do
		for _, pname in ipairs(team) do
			if name == pname then return k end
		end
	end
end

minetest.register_on_joinplayer(function(player)
    local pname = player:get_player_name() 
    table.insert(sumo_deuls.teams[lobby], pname)
end)

function sumo_duels.set_playing(player, arena_number)
	--nothing yet
end

minetest.register_globalstep(function(dtime)
	if #sumo_deuls.teams[arena_1] == 0 then --noone in arena1
			if #sumo_deuls.teams[waiting_arena_1] >= 2 then
				sumo_duels.set_playing(player, arena_number)
			end
	end
end)
