sumo_duels.messages = {"You can join the waiting list for an arena using /join <number from 1 to 3>", "The longer you wait to hit your opponent, the more knockback you do"}

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime;
	if timer >= 5 then
		-- Send message to all players every 5 seconds
    local random = math.random(1, #sumo_duels.messages)
		minetest.chat_send_all(minetest.colorize("#999997", sumo_duels.messages[random]))
		timer = 0
	end
end)
