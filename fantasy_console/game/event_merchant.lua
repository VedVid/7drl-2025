local dice = require "game/dice"
local items = require "game/items"
local map = require "game/map"
local player = require "game/player"


local event = {}
event.header = "You met this friendly merchant.\nMaybe browse his wares?"
event.options = {
    "Purchase",
    "Sell",
    "Steal from",
    "Leave"
}
event.purchasing_options = {}
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

function event.reset()
    event.angry = false
    event.inventory = {}
    event.prices_overall = event.prices_normal
end

function event.generate_inventory()
    local inventory_size = math.random(2, 4)
    for i = 1, inventory_size do
        table.insert(event.inventory, items.items[math.random(#items.items)])
    end
end

function event.generate_purchasing_options()
    for _, v in ipairs(event.inventory) do
        table.insert(event.purchasing_options, v.name)
    end
    table.insert(event.purchasing_options, "Go back")
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

function event.check_if_in_inventory(s)
    for _, v in ipairs(event.inventory) do
        if string.find(s.name, v) then
            return true
        end
    end
    return false
end

function event.player_purchase_from_merchant(item_index)
    local item = event.inventory[item_index]
    if player.gold < item.price then return end
    if item == dice.red or item == dice.gold then
        if player.add_to_inventory(item) == true then
            player.gold = player.gold - item.price
            --table.remove(event_merchant.inventory, item_index)
        end
    else
        do end -- handle other items there TODO
    end
end

return event
