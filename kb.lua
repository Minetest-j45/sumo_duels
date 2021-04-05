minetest.calculate_knockback = function(player, hitter, time_from_last_punch, tool_capabilities, dir, distance, damage)
    player:set_hp(20)
    if not time_from_last_punch or time_from_last_punch >= 1.5 then
        return 15
    elseif time_from_last_punch <= 1 and time_from_last_punch >= 0.5 then
        return 10
    else
        return 5
    end
end
