sumo_deuls.teams = {lobby = {}, waiting_arena_1 = {}, arena_1 = {}}

sumo_deuls.get_player_team = function(name)
	for k, team in pairs(sumo_deuls.teams) do
		for _, pname in ipairs(team) do
			if name == pname then return k end
		end
	end
end

sumo_duels.set_playing = function(pname, arena_number)
	table.remove(sumo_duels[waiting_arena_ .. arena_number], pname)
	--set pos arena_1
	table.insert(sumo_duels[arena_ .. arena_number], pname)
end

sumo_duels.set_waiting = function(pname, arena_number)
	table.remove(sumo_duels[lobby], pname)
	--set pos lobby
	table.insert(sumo_duels[waiting_arena_ .. arena_number], pname)
end

sumo_duels.set_lobby = function(pname)
	local current = sumo_deuls.get_player_team(pname)
	table.remove(current, pname)
	--set pos lobby
	table.insert(sumo_duels[lobby], pname)
end

minetest.register_on_joinplayer(function(player)
    local pname = player:get_player_name()
    table.insert(sumo_deuls.teams[lobby], pname)
end)

minetest.register_chatcommand("join", {
	params = "number",
	description = "Join the waiting list for an arena",
	privs = {play = true},
	func = function(name, number)
		if not 
		local number = number or "1"
		local player = minetest.get_player_by_name(name)
		if not player then return end
		if not player:is_player() then return end
		sumo_duels.set_waiting(name, number)
	end,
})

minetest.register_globalstep(function(dtime)
	if #sumo_deuls.teams[arena_1] == 0 then --noone in arena1
		if #sumo_deuls.teams[waiting_arena_1] >= 2 then
			for name, sumo_duels.teams[waiting_arena_1] = 1,2 do
				sumo_duels.set_playing(name, "1")
			end
		end
	elseif #sumo_deuls.teams[arena_1] == 1 then
		for name, sumo_duels.teams[arena_1] = 1 do
			sumo_duels.set_lobby(name, arena_1)
		end
	end
end)
