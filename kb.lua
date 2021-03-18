minetest.calculate_knockback = function(player, hitter, time_from_last_punch, tool_capabilities, dir, distance, damage)
	if not time_from_last_punch then return end
	if time_from_last_punch >= 1.5 then
		return 1.5
	elseif time_from_last_punch <= 1 and time_from_last_punch >= 0.5 then
		return 1
	else
		return 0.5
	end
end
