local dice = require "game/dice"
local states = require "game/states"
local utils = require "game/utils"


local player = {}

player.skills = {
    {"physique", 5},
    {"cunning", 5},
    {"empathy", 5},
    {"health", 5}
}

player.max_health = 0
player.current_health = 0
player.gold = 50

-- It will be kinda hack. Since there are only two additional dice (red and gold),
-- we can assume that reds are first and golds are last.
player.inventory = {}
player.inventory_max = 8
player.inventory_chosen = 1
player.inventory_marked_for_use = {}

function player.set_random_skills()
    if Tutorial > 0 then
        player.skills = {
            {"physique", 5},
            {"cunning", 5},
            {"empathy", 5},
            {"health", 5}
        }
        player.max_health = player.skills[4][2]
        player.current_health = player.max_health
        return
     end
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
    if #player.inventory >= player.inventory_max then return false end
    if die == dice.red then
        table.insert(player.inventory, 1, dice.red)
    else
        table.insert(player.inventory, dice.gold)
    end
    return true
end

function player.remove_from_inventory(die)
    assert(die == dice.red or die == dice.gold, "die should be only red or gold")
    if die == dice.red and player.inventory[1] == dice.red then
        return table.remove(player.inventory, 1)
    elseif die == dice.gold and player.inventory[#player.inventory] == dice.gold then
        return table.remove(player.inventory, #player.inventory)
    end
end

function player.handle_dice_marking()
    if not utils.has_value(player.inventory_marked_for_use, player.inventory_chosen) then
        table.insert(player.inventory_marked_for_use, player.inventory_chosen)
    else
        for i, v in ipairs(player.inventory_marked_for_use) do
            if v == player.inventory_chosen then
                table.remove(player.inventory_marked_for_use, i)
            end
        end
    end
end

function player.make_a_roll(current_action, current_skill)
    State = states.rolling
    Action = current_action
    local dices = {}
    for i = 1, current_skill[2] do
        table.insert(dices, dice.green)
    end
    for i, n in ipairs(player.inventory_marked_for_use) do
        if player.inventory[n] == dice.red then
            table.insert(dices, dice.red)
        elseif player.inventory[n] == dice.gold then
            table.insert(dices, dice.gold)
        end
    end
    for _, die in ipairs(dices) do
        if die == dice.red or die == dice.gold then
            player.remove_from_inventory(die)
        end
    end
    player.inventory_marked_for_use = {}
    Rolls = dice.generate_rolls(dices, 7)
    Current_side = 1
    dice.update_last_results(Rolls, Current_side)
  end

return player
