sumo_deuls.teams = {lobby = {}, waiting_arena_1 = {}, arena_1 = {}}

local lobby_pos = {x = 0, y = 0, z = 0}

sumo_deuls.get_player_team = function(name)
	for k, team in pairs(sumo_deuls.teams) do
		for _, pname in ipairs(team) do
			if name == pname then return k end
		end
	end
end

local other_player
sumo_deuls.get_other_team_player = function(name)
	local current = sumo_deuls.get_player_team(name)
	for _, player in pairs(sumo_deuls.teams[current]) do
		local pname = player:get_player_name()
		if not name == pname then other_player = pname end
	end
end

sumo_duels.set_playing = function(pname, arena_number)
	local current = sumo_deuls.get_player_team(pname)
	table.remove(current, pname)
	--set pos arena_1
	table.insert(sumo_duels[arena_ .. arena_number], pname)
end

sumo_duels.set_waiting = function(pname, arena_number)
	local current = sumo_deuls.get_player_team(pname)
	table.remove(current, pname)
	local player = minetest.get_player_by_name(pname)
	player:set_pos(lobby_pos)
	table.insert(sumo_duels[waiting_arena_ .. arena_number], pname)
end

sumo_duels.set_lobby = function(pname)
	local current = sumo_deuls.get_player_team(pname)
	table.remove(current, pname)
	local player = minetest.get_player_by_name(pname)
	player:set_pos(lobby_pos)
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
		for _, name in ipairs(sumo_duels.teams[arena_1]) do
			minetest.chat_send_player(name, "Your opponent left. GG in a way. lol")
			sumo_duels.set_lobby(name, arena_1)
		end
	end
end)

minetest.register_on_dieplayer(function(player)
	sumo_deuls.get_other_team_player(player:get_player_name())
	minetest.chat_send_player(other_player, "Your opponent died! GG, you win")
	for _, teamplayer in ipairs(sumo_duels.teams[sumo_deuls.get_player_team[player:get_player_name()]]) do
		sumo_duels.set_lobby(teamplayer:get_player_name())
	end
end)
