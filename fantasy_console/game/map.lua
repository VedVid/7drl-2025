local map = {}

map.current_room = "start"
map.travel_destination = 0
map.doors_to = {}
map.possible_doors = {
    "merchant",
    "event",
    "combat"
}
map.door_names = {}
map.door_names.merchant = "merchant"
map.door_names.event = "event"
map.door_names.combat = "combat"
map.door_names.start = "start"

function map.generate_rooms()
    map.doors_to = {}
    if Tutorial == 1 then
        table.insert(map.doors_to, map.door_names.combat)
    elseif Tutorial == 3 then
        table.insert(map.doors_to, map.door_names.merchant)
    else
        local amount_of_rooms = math.random(3)
        if amount_of_rooms == 1 then
            table.insert(map.doors_to, map.possible_doors[math.random(#map.possible_doors)])
        else
            for i = 1, amount_of_rooms do
                local chances = math.random(80)
                if chances <= 20 then
                    table.insert(map.doors_to, map.door_names.merchant)
                elseif chances <= 40 then
                    table.insert(map.doors_to, map.door_names.event)
                else
                    table.insert(map.doors_to, map.door_names.combat)
                end
            end
        end
    end
end

function map.travel()
    if map.travel_destination > # map.doors_to then return end
    map.current_room = map.doors_to[map.travel_destination]
    map.generate_rooms()
end


return map