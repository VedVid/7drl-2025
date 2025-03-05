local map = require "game/map"


local event = {}
event.header = "This is random event."
event.options = {"Proceed"}
event.base_options = {"Proceed"}


event.events = {}

--event.infighting = {}
--event.header = "You see two groups fighting\neach other.\nWhat do you do?"
--event.options = {
--    "Help the smaller group",
--    "Help the larger group"
--}


event.free_meal = {}
event.free_meal.header = "You see an iron ration on table."
event.free_meal.options = {"Yum!"}
table.insert(event.events, event.free_meal)

event.decrease_danger = {}
event.decrease_danger.header = "You see a poster with your likeness\nhanged on the wall."
event.decrease_danger.options = {"Tear down the poster!"}
table.insert(event.events, event.decrease_danger)


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
