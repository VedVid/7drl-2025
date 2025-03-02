require "../api"

local event_combat = require "game/event_combat"
local event_merchant = require "game/event_merchant"
local event_random = require "game/event_random"
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
    if string.find(v, events_options.go_to_first_room) then
        State = states.travel
        Travel_anim_x = 2
        map.travel_destination = 1
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
        elseif string.find(v, map.door_names.combat) then
            Current_event = event_combat
        elseif string.find(v, map.door_names.event) then
            Current_event = event_random
        end
    end
end


return menu
