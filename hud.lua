sumo_duels.huds = {}
sumo_duels.hud_team_info = {}

sumo_duels.std_hud = {
	hud_elem_type = "text",
	position = {x = 0.85, y = 0.3},
	offset = {x = 20, y = 20},
	text = "",
	alignment = {x = 1, y = 1},
	scale = {x = 100, y = 100},
	number = 0xFFFFFF,
}

minetest.register_on_joinplayer(function(player)
	sumo_duels.huds[player:get_player_name()] = player:hud_add(sumo_duels.std_hud)
	minetest.after(1, sumo_duels.hud_update, nil)
end)

sumo_duels.hud_update = function()
	local players = minetest.get_connected_players()
	for _, player in ipairs(players) do
		local pname = player:get_player_name()
		for _, team in iparis(sumo_duels.teams) do
			sumo_duels.hud_team_info[team] = tostring(#sumo_duels.teams[team])
		end
		local text = "You are in: " .. sumo_duels.get_player_team(pname) .. "\n" ..
		"Lobby: " .. sumo_duels.hud_team_info["lobby"] .. "\n" ..
		
		"Waiting Arena 1: " .. sumo_duels.hud_team_info["waiting_arena_1"] .. "\n" ..
		"Arena 1: " .. sumo_duels.hud_team_info["arena_1"] .. "\n" ..
		
		"Waiting Arena 2: " .. sumo_duels.hud_team_info["waiting_arena_2"] .. "\n" ..
		"Arena 2: " .. sumo_duels.hud_team_info["arena_2"] .. "\n" ..
		
		"Waiting Arena 3: " .. sumo_duels.hud_team_info["waiting_arena_3"] .. "\n" ..
		"Arena 3: " .. sumo_duels.hud_team_info["arena_3"]
		
		player:hud_change(sumo_duels.huds[pname], "text", text)
	end
end
