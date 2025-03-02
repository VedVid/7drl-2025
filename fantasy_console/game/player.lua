local dice = require "game/dice"


local player = {}

player.skills = {
    {"physique", 5},
    {"cunning", 5},
    {"empathy", 5},
    {"health", 5}
}

player.max_health = 0
player.current_health = 0

-- It will be kinda hack. Since there are only two additional dice (red and gold),
-- we can assume that reds are first and golds are last.
player.inventory = {}
player.inventory_max = 8

function player.set_random_skills()
    local iterations = 4
    for i = 1, iterations do
        local skill_buff = math.random(4)
        local skill_nerf = math.random(4)
        player.skills[skill_buff][2] = player.skills[skill_buff][2] + 1
        player.skills[skill_nerf][2] = player.skills[skill_nerf][2] - 1
    end
    player.max_health = player.skills[4][2]
    player.current_health = player.max_health
end

function player.add_to_inventory(die)
    assert(die == dice.red or die == dice.gold, "die should be only red or gold")
    if #player.inventory >= player.inventory_max then return end
    if die == dice.red then
        table.insert(player.inventory, 1, dice.red)
    else
        table.insert(player.inventory, dice.gold)
    end
end

function player.remove_from_inventory(die)
    assert(die == dice.red or die == dice.gold, "die should be only red or gold")
    if die == dice.red and player.inventory[1] == dice.red then
        return table.remove(player.inventory, 1)
    elseif die == dice.gold and player.inventory[#player.inventory] == dice.gold then
        return table.remove(player.inventory, #player.inventory)
    end
end


return player
