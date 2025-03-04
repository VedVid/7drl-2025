local dice = require "game/dice"


local map = require "game/map"


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
    local gold = math.random(5, 20) * Base_difficulty
    local s = "You looted " .. gold .. "GP"
    local dices = {}
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
        table.insert(dices, die_type)
    end
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
