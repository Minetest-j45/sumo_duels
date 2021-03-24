sumo_duels.messages = {
	"You can join the waiting list for an arena using /join <number from 1 to 3>",
	"The longer you wait to hit your opponent, the more knockback you do",
	"Once there are at least 2 people in a waiting list for an arena, the first 2 people who were in the waiting list will be put in a game"
}

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
