sumo_duels.teams = {lobby = {}, waiting_arena_1 = {}, arena_1 = {}, waiting_arena_2 = {}, arena_2 = {}, waiting_arena_3 = {}, arena_3 = {}}
sumo_duels.team_names = {"lobby", "waiting_arena_1", "arena_1", "waiting_arena_2", "arena_2", "waiting_arena_3", "arena_3"}

local lobby_pos = {x = 0, y = 100, z = 0}
local arena_1_pos = {x = 0, y = 81, z = 7}
local arena_2_pos = {x = 8, y = 81, z = -7}
local arena_3_pos = {x = -8, y = 81, z = -7}

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
	local player = minetest.get_player_by_name(pname)
	if arena_number == "1" then
		player:set_pos(arena_1_pos)
	elseif arena_number == "2" then
		player:set_pos(arena_2_pos)
	elseif arena_number == "3" then
		player:set_pos(arena_3_pos)
	end
	table.insert(sumo_duels.teams["arena_" .. arena_number], pname)
	sumo_duels.hud_update()
end

sumo_duels.set_waiting = function(pname, arena_number)
	local current = sumo_duels.get_player_team(pname)
	if current:match("^arena_%d+") then return false, "You are in a game, dont try escape" end
	local tablenumber = sumo_duels.tablefind(sumo_duels.teams[current], pname)
	table.remove(sumo_duels.teams[current], tonumber(tablenumber))
	local player = minetest.get_player_by_name(pname)
	player:set_pos(lobby_pos)
	table.insert(sumo_duels.teams["waiting_arena_" .. arena_number], pname)
	sumo_duels.hud_update()
end

sumo_duels.set_lobby = function(pname)
	local current = sumo_duels.get_player_team(pname)
	local tablenumber = sumo_duels.tablefind(sumo_duels.teams[current], pname)
	table.remove(sumo_duels.teams[current], tonumber(tablenumber))
	local player = minetest.get_player_by_name(pname)
	player:set_pos(lobby_pos)
	table.insert(sumo_duels.teams.lobby, pname)
	sumo_duels.hud_update()
end

minetest.register_on_joinplayer(function(player)
    local pname = player:get_player_name()
    table.insert(sumo_duels.teams.lobby, pname)
end)

minetest.register_on_leaveplayer(function(player)
	local pname = player:get_player_name()
	local current = sumo_duels.get_player_team(pname)
	local tablenumber = sumo_duels.tablefind(sumo_duels.teams[current], pname)
	table.remove(sumo_duels.teams[current], tonumber(tablenumber))
	sumo_duels.hud_update()
end)

minetest.register_chatcommand("join", {
	params = "number",
	description = "Join the waiting list for an arena",
	privs = {play = true},
	func = function(name, number)
		if not name then return end
		local player = minetest.get_player_by_name(name)
		if not player then return end
		if not player:is_player() then return end
		if number == "1" or number == "2" or number == "3" then
			sumo_duels.set_waiting(name, number)
		else return false, "You must put a number from 1 to 3 to join a waiting list for an arena" end
	end,
})

minetest.register_chatcommand("lobby", {
	description = "Join lobby (only use this to exit the queue for an arena)",
	privs = {play = true},
	func = function(name, _)
		if not name then return end
		local player = minetest.get_player_by_name(name)
		if not player then return end
		if not player:is_player() then return end
		local current = sumo_duels.get_player_team(name)
		if current:match("^arena_%d+") then return false, "You are in a game, dont try escape" end
		sumo_duels.set_lobby(name)
	end,
})

minetest.register_globalstep(function(dtime)--for arena_1 and its waiting list
	if #sumo_duels.teams.arena_1 == 0 then --noone in arena_1
		if #sumo_duels.teams.waiting_arena_1 >= 2 then
			sumo_duels.set_playing(sumo_duels.teams.waiting_arena_1[1], "1") 
			sumo_duels.set_playing(sumo_duels.teams.waiting_arena_1[1], "1") 
		end
	elseif #sumo_duels.teams.arena_1 == 1 then
		for _, name in ipairs(sumo_duels.teams.arena_1) do
			minetest.chat_send_player(name, "Your opponent left. GG in a way. lol")
			sumo_duels.set_lobby(name)
		end
	end
end)
minetest.register_globalstep(function(dtime)--for arena_2 and its waiting list
	if #sumo_duels.teams.arena_2 == 0 then --noone in arena_2
		if #sumo_duels.teams.waiting_arena_2 >= 2 then
			sumo_duels.set_playing(sumo_duels.teams.waiting_arena_2[1], "1") 
			sumo_duels.set_playing(sumo_duels.teams.waiting_arena_2[1], "1") 
		end
	elseif #sumo_duels.teams.arena_2 == 1 then
		for _, name in ipairs(sumo_duels.teams.arena_2) do
			minetest.chat_send_player(name, "Your opponent left. GG in a way. lol")
			sumo_duels.set_lobby(name)
		end
	end
end)
minetest.register_globalstep(function(dtime)--for arena_3 and its waiting list
	if #sumo_duels.teams.arena_3 == 0 then --noone in arena_3
		if #sumo_duels.teams.waiting_arena_3 >= 2 then
			sumo_duels.set_playing(sumo_duels.teams.waiting_arena_3[1], "1") 
			sumo_duels.set_playing(sumo_duels.teams.waiting_arena_3[1], "1") 
		end
	elseif #sumo_duels.teams.arena_3 == 1 then
		for _, name in ipairs(sumo_duels.teams.arena_3) do
			minetest.chat_send_player(name, "Your opponent left. GG... in a way. lol")
			sumo_duels.set_lobby(name)
		end
	end
end)

minetest.register_on_dieplayer(function(player)
	local team = sumo_duels.get_player_team(player:get_player_name())
	if not team == "arena_1" or not team == "arena_2" or not team == "arena_3" then return end
	if sumo_duels.get_other_team_player(player:get_player_name()) then
		minetest.chat_send_player(sumo_duels.get_other_team_player(player:get_player_name()), "Your opponent died! GG, you win")
	end
	for _, teamplayer in ipairs(sumo_duels.teams[team]) do
		sumo_duels.set_lobby(teamplayer)
	end
end)
