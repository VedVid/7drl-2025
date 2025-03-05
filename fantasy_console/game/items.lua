local items = {}


function items.new_item(name, boost, nerf)
    local item = {}
    item.name = name
    if boost == nil then boost = {} end
    if nerf == nil then nerf = {} end
    item.boost = boost
    item.nerf = nerf
    local price = math.random(15, 30)
    price = price + (10 * #boost)
    price = price - (5 * #nerf)
    item.price = price
    return item
end


items.items = {}

items.dice_red = {}
items.dice_red.name = "Red die"
items.dice_red.price = 20
table.insert(items.items, items.dice_red)

items.items.dice_gold = {}
items.items.dice_gold.name = "Gold die"
items.items.dice_gold.price = 40
table.insert(items.items, items.dice_gold)

items.potion_of_strength = items.new_item(
    -- first number is skill number, second number is boost amount
    "Potion of strength", {{1, 1}}
)
table.insert(items.items, items.potion_of_strength)

items.potion_of_cunning = items.new_item(
    "Potion of cunning", {{2, 1}}
)
table.insert(items.items, items.potion_of_cunning)

items.potion_of_empathy = items.new_item(
    "Potion of empathy", {{3, 1}}
)
table.insert(items.items, items.potion_of_empathy)

items.heavy_shoes = items.new_item(
    "Heavy shoes", {{1, 2}}, {{2, 1}}
)
table.insert(items.items, items.heavy_shoes)

items.heavy_armor = items.new_item(
    "Heavy armor", {{1, 3}}, {{2, 2}}
)
table.insert(items.items, items.heavy_armor)

items.dagger = items.new_item(
    "Dagger", {{1, 1}, {2, 1}}, {{3, 2}}
)
table.insert(items.items, items.dagger)

items.sling = items.new_item(
    "Sling", {{1, 1}, {2, 1}}
)
table.insert(items.items, items.sling)

items.royal_sword = items.new_item(
    "Royal sword", {{1, 2}, {3, 2}}, {{2, 1}}
)
table.insert(items.items, items.royal_sword)

items.card_deck = items.new_item(
    "Card deck", {{2, 1}, {3, 1}}
)
table.insert(items.items, items.card_deck)


return items
