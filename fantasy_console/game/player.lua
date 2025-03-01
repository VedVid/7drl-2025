local player = {}

player.skills = {
    {"physique", 5},
    {"precision", 5},
    {"logic", 5},
    {"empathy", 5},
    {"health", 5}
}

player.max_health = 0
player.current_health = 0

-- It will be kinda hack. Since there are only two additional dice (red and gold),
-- we can assume that reds are first and golds are last.
player.inventory = {}

function player.set_random_skills()
    local iterations = 4
    for i = 1, iterations do
        local skill_buff = math.random(5)
        local skill_nerf = math.random(5)
        player.skills[skill_buff][2] = player.skills[skill_buff][2] + 1
        player.skills[skill_nerf][2] = player.skills[skill_nerf][2] - 1
    end
    player.max_health = player.skills[5][2]
    player.current_health = player.max_health
end

return player
