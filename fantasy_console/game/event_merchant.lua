local dice = require "game/dice"
local map = require "game/map"


local event = {}
event.header = "You met this friendly merchant.\nMaybe browse his wares?"
event.options = {
    "Purchase",
    "Sell",
    "Steal from",
    "Leave"
}
event.base_options = {
    "Purchase",
    "Sell",
    "Steal from",
    "Leave"
}
event.angry = false
event.price_modifier = 1
event.prices_inexpensive = 0.75
event.prices_normal = 1
event.prices_expensive = 1.25
event.prices_overall = event.prices_normal
event.inventory = {}
event.possible_items = {
    dice.red,
    dice.gold
}

function event.reset()
    event.angry = false
    event.inventory = {}
    event.prices_overall = event.prices_normal
end

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

return event
