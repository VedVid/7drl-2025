local map = require "game/map"


local event = {}
event.header = "You met this friendly merchant.\nMaybe browse his wares?"
event.options = {
    "Purchase",
    "Sell",
    "Steal",
    "Leave"
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

return event
