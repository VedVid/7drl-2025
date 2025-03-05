local map = require "game/map"


local event = {}
event.header = ""
event.options = {""}
event.base_options = {""}


event.events = {}

event.free_meal = {}
event.free_meal.header = "You see an iron ration on table."
event.free_meal.options = {"Yum!"}
--table.insert(event.events, event.free_meal)

event.decrease_danger = {}
event.decrease_danger.header = "You see a poster with your likeness\nhanged on the wall."
event.decrease_danger.options = {"Tear down the poster!"}
--table.insert(event.events, event.decrease_danger)

event.fresh_corpse = {}
event.fresh_corpse.header = "You see a fresh corpse on the floor.\nSomeone was there before you..."
event.fresh_corpse.options = {"Search the pockets", "Do not disturb the corpse"}
--table.insert(event.events, event.fresh_corpse)

event.infighting = {}
event.infighting.header = "You see two groups fighting\neach other.\nWhat do you do?"
event.infighting.options = {
    "Help the smaller group",
    "Help the larger group",
    "Do not interfere"
}
table.insert(event.events, event.infighting)


function event.reset()
    event.header = ""
    event.options = event.base_options
end


function event.choose_and_update_event()
    local current_event = event.events[math.random(#event.events)]
    event.header = current_event.header
    event.options = current_event.options
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
