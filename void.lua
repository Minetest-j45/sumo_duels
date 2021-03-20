local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= 1 then
		local players = minetest.get_connected_players()
		for _, player in ipairs(players) do
			if player:get_pos().y < 80 then
				player:set_hp(0)
			end
		end
		timer = 0
	end
end)
