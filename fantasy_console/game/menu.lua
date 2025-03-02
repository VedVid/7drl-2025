require "../api"

local events_options = require "game/events_options"
local map = require "game/map"
local states = require "game/states"


local menu = {}

menu.current_menu = nil
menu.option_chosen = 1

function menu.new_menu(event)
    local new_menu = {}
    new_menu.event = event
    new_menu.header = event.header
    new_menu.options = event.options
    return new_menu
end

function menu.choose_option()
    local v = menu.current_menu.options[menu.option_chosen]
    if Sub(v, 1, 16) == events_options.go_to_first_room then
        State = states.travel
        Travel_anim_x = 2
        map.travel_destination = 1
    elseif Sub(v, 1, 17) == events_options.go_to_second_room then
        State = states.travel
        Travel_anim_x = 2
        map.travel_destination = 2
    elseif Sub(v, 1, 16) == events_options.go_to_third_room then
        State = states.travel
        Travel_anim_x = 2
        map.travel_destination = 3
    end
end


return menu
