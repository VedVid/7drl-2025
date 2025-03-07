local dice = require "game/dice"
local map = require "game/map"
local player = require "game/player"


local event = {}
event.header = "Hostile encounter!\nWhat do you do?"
event.options = {
    "Fight",
    "Try to flee",
    "Try diplomacy"
}
event.base_options = {
    "Fight",
    "Try to flee",
    "Try diplomacy"
}

function event.generate_travel_options()
    event.options = {}
    for i, room in ipairs(map.doors_to) do
        local number = "first"
        if i == 2 then
            number = "second"
        elseif i == 3 then
            number = "third"
        end
        local s = "Go to " .. number .. " room [" .. room .. "]"
        table.insert(event.options, s)
    end
end

function event.grant_rewards()
    if Tutorial > 0 then
        player.gold = player.gold + 50
        return "Looted 50 GP."
    end
    local gold = math.random(5, 20) * Base_difficulty
    local chance = math.random(101)
    local amount = 0
    local reds = 0
    local golds = 0
    if chance <= 50 then
        amount = 1
    elseif chance <= 80 then
        amount = 2
    elseif chance <= 98 then
        amount = 3
    else
        amount = 4
    end
    for i = 1, amount do
        local die_type = dice.red
        reds = reds + 1
        if math.random(101) <= 30 then
            die_type = dice.gold
            reds = reds - 1
            golds = golds + 1
        end
        if not player.add_to_inventory(die_type) then
            if die_type == dice.red then
                reds = reds - 1
                gold = gold + 15
            elseif die_type == dice.gold then
                golds = golds - 1
                gold = gold + 30
            end
        end
    end
    player.gold = player.gold + gold
    local s = "Looted: " .. gold .. "GP"
    if reds > 0 then
        s = s .. ", " .. reds .. "x red die"
    end
    if golds > 1 then
        s = s .. ", " .. golds .. "x gold die"
    end
    s = s .. "."
    return s
end

return event
