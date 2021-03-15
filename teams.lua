sumo_deuls.teams = {lobby = {}, waiting_arena_1 = {}, arena_1 = {}}

minetest.register_on_joinplayer(function(player)
    local pname = player:get_player_name() 
    table.insert(sumo_deuls.teams[lobby], pname)
end)
