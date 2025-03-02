local map = {}

map.current_room = "combat"
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
    local amount_of_rooms = math.random(3)
    for i = 1, amount_of_rooms do
        table.insert(map.doors_to, map.possible_doors[math.random(#map.possible_doors)])
    end
end

function map.travel_to(room_no)
    if room_no > # map.doors_to then return end
    map.current_room = map.doors_to[room_no]
    map.generate_rooms()
    print(map.current_room)
end

return map