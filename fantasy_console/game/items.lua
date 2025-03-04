local player = require "game/player"


local items = {}


items.items = {}

items.items.dice_red = {}
items.items.dice_red.name = "Red die"
items.items.dice_red.price = 20

items.items.dice_gold = {}
items.items.dice_gold.name = "Gold die"
items.items.dice_gold.price = 40

items.items.potion_of_strength = items.new_item(
    "Potion of strength", {{player.skills[1], 1}}
)

items.items.potion_of_cunning = items.new_item(
    "Potion of cunning", {{player.skills[2], 1}}
)

items.items.potion_of_empathy = items.new_item(
    "Potion of empathy", {{player.skills[3], 1}}
)

items.items.heavy_shoes = items.new_item(
    "Heavy shoes", {{player.skills[1], 2}}, {{player.skills[2], 1}}
)


function items.new_item(name, boost, nerf)
    local item = {}
    item.name = name
    if nerf == nil then nerf = {} end
    if #boost >= 1 then
        item.boost_skill_1 = boost[1][1]
        item.boost_still_1_amount = boost[1][2]
    end
    if #boost >= 2 then
        item.boost_skill_2 = boost[2][1]
        item.boost_skill_2_amount = boost[2][2]
    end
    if #boost == 3 then
        item.boost_skill_3 = boost[3][1]
        item.boost_skill_3_amount = boost[3][2]
    end
    if #nerf >= 1 then
        item.nerf_skill_1 = nerf[1][1]
        item.nerf_skill_1_amount = nerf[1][2]
    end
    if #nerf >= 2 then
        item.nerf_skill_2 = nerf[2][1]
        item.nerf_skill_2_amount = nerf[2][2]
    end
    if #nerf == 3 then
        item.nerf_skill_3 = nerf[3][1]
        item.nerf_skill_3_amount = nerf[3][2]
    end
    local price = math.random(15, 30)
    price = price + (10 * #boost)
    price = price - (5 * #nerf)
    item.price = price
    return item
end


return items
