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
    event.purchasing_options = {}
    for _, v in ipairs(event.inventory) do
        local s = v.name
        if v ~= items.dice_red and v ~= items.dice_gold then
            if #v.boost > 0 or #v.nerf > 0 then
                s = s .. " {"
                for _, z in ipairs(v.boost) do
                    local boost_symbol = ""
                    if z[1] == 1 then
                        boost_symbol = "P+"
                    elseif z[1] == 2 then
                        boost_symbol = "C+"
                    elseif z[1] == 3 then
                        boost_symbol = "E+"
                    else
                        print("icorrect boost symbol")
                    end
                    s = s .. boost_symbol .. z[2]
                end
                for _, z in ipairs(v.nerf) do
                    local nerf_symbol = ""
                    if z[1] == 1 then
                        nerf_symbol = "P-"
                    elseif z[1] == 2 then
                        nerf_symbol = "C-"
                    elseif z[1] == 3 then
                        nerf_symbol = "E-"
                    else
                        print("icorrect boost symbol")
                    end
                    s = s .. nerf_symbol .. z[2]
                end
                s = s .. "}"
            end
        end
        s = s .. " [" .. v.price .. "$]"
        table.insert(event.purchasing_options, s)
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
        if string.find(s, v.name) then
            return true
        end
    end
    return false
end

function event.player_purchase_from_merchant(item_index)
    local item = event.inventory[item_index]
    if player.gold < item.price then return end
    if string.find(item.name, "Red die") then
        if player.add_to_inventory(dice.red) == true then
            player.gold = player.gold - item.price
            table.remove(event.inventory, item_index)
        end
    elseif string.find(item.name, "Gold die") then
        if player.add_to_inventory(dice.gold) == true then
            player.gold = player.gold - item.price
            table.remove(event.inventory, item_index)
        end
    else
        for _, v in ipairs(item.boost) do
            local skill_to_buff = v[1]
            player.skills[skill_to_buff][2] = player.skills[skill_to_buff][2] + v[2]
        end
        for _, v in ipairs(item.nerf) do
            local skill_to_nerf = v[1]
            player.skills[skill_to_nerf][2] = player.skills[skill_to_nerf][2] - v[2]
            if player.skills[skill_to_nerf] < 1 then
                player.skills[skill_to_nerf] = 1
            end
        end
        player.gold = player.gold - item.price
        table.remove(event.inventory, item_index)
    end
end

return event
