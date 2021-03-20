sumo_duels.teams = {lobby = {}, waiting_arena_1 = {}, arena_1 = {}}

local lobby_pos = {x = 0, y = 0, z = 0}--set world spawn to this too

sumo_duels.tablefind = function(tab,el)
	for index, value in pairs(tab) do
		if value == el then
			return index
		end
	end
end

sumo_duels.get_player_team = function(name)
	for k, team in pairs(sumo_duels.teams) do
		for _, pname in ipairs(team) do
			if name == pname then return k end
		end
	end
end

sumo_duels.get_other_team_player = function(name)
	local current = sumo_duels.get_player_team(name)
	for k, playername in pairs(sumo_duels.teams[current]) do
		if not name == playername then return k end
	end
end

sumo_duels.set_playing = function(pname, arena_number)
	local current = sumo_duels.get_player_team(pname)
	local tablenumber = sumo_duels.tablefind(sumo_duels.teams[current], pname)
	table.remove(sumo_duels.teams[current], tonumber(tablenumber))
	--set pos arena_1
	table.insert(sumo_duels.teams["arena_" .. arena_number], pname)
	minetest.chat_send_all(dump(sumo_duels.teams))
end

sumo_duels.set_waiting = function(pname, arena_number)
	local current = sumo_duels.get_player_team(pname)
	local tablenumber = sumo_duels.tablefind(sumo_duels.teams[current], pname)
	table.remove(sumo_duels.teams[current], tonumber(tablenumber))
	local player = minetest.get_player_by_name(pname)
	player:set_pos(lobby_pos)
	table.insert(sumo_duels.teams["waiting_arena_" .. arena_number], pname)
	minetest.chat_send_all(dump(sumo_duels.teams))
end

sumo_duels.set_lobby = function(pname)
	local current = sumo_duels.get_player_team(pname)
	local tablenumber = sumo_duels.tablefind(sumo_duels.teams[current], pname)
	table.remove(sumo_duels.teams[current], tonumber(tablenumber))
	local player = minetest.get_player_by_name(pname)
	player:set_pos(lobby_pos)
	table.insert(sumo_duels.teams.lobby, pname)
	minetest.chat_send_all(dump(sumo_duels.teams))
end

minetest.register_on_joinplayer(function(player)
    local pname = player:get_player_name()
    table.insert(sumo_duels.teams.lobby, pname)
    minetest.chat_send_all(dump(sumo_duels.teams))
end)

minetest.register_chatcommand("join", {
	params = "number",
	description = "Join the waiting list for an arena",
	privs = {play = true},
	func = function(name, number)
		if not name then return end
		local number = number or "1"
		local player = minetest.get_player_by_name(name)
		if not player then return end
		if not player:is_player() then return end
		sumo_duels.set_waiting(name, number)
	end,
})

minetest.register_globalstep(function(dtime)
	if #sumo_duels.teams.arena_1 == 0 then --noone in arena1
		if #sumo_duels.teams.waiting_arena_1 >= 2 then
			sumo_duels.set_playing(sumo_duels.teams.waiting_arena_1[1], "1") 
			sumo_duels.set_playing(sumo_duels.teams.waiting_arena_1[1], "1") 
		end
	elseif #sumo_duels.teams.arena_1 == 1 then
		for _, name in ipairs(sumo_duels.teams.arena_1) do
			minetest.chat_send_player(name, "Your opponent left. GG in a way. lol")
			sumo_duels.set_lobby(name, "arena_1")
		end
	end
end)

minetest.register_on_dieplayer(function(player)
	local team = sumo_duels.get_player_team(player:get_player_name())
	if not team == "arena_1" then return end
	if sumo_duels.get_other_team_player(player:get_player_name()) then
		minetest.chat_send_player(sumo_duels.get_other_team_player(player:get_player_name()), "Your opponent died! GG, you win")
	end
	for _, teamplayer in ipairs(sumo_duels.teams[team]) do
		sumo_duels.set_lobby(teamplayer)
	end
end)
