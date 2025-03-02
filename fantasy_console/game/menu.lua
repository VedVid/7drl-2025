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
        local new_menu = nil
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
            Current_event.generate_travel_options()
            new_menu = menu.new_menu(event_merchant)
        elseif string.find(v, map.door_names.combat) then
            Current_event = event_combat
            Current_event.generate_travel_options()
            new_menu = menu.new_menu(event_combat)
        elseif string.find(v, map.door_names.event) then
            Current_event = event_random
            Current_event.generate_travel_options()
            new_menu = menu.new_menu(event_random)
        end
        menu.current_menu = new_menu
        Travel_anim_x = 2
        map.travel_destination = 1
        State = states.travel
    elseif string.find(v, events_options.go_to_second_room) then
        local new_menu = nil
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
            Current_event.generate_travel_options()
            new_menu = menu.new_menu(event_merchant)
        elseif string.find(v, map.door_names.combat) then
            Current_event = event_combat
            Current_event.generate_travel_options()
            new_menu = menu.new_menu(event_combat)
        elseif string.find(v, map.door_names.event) then
            Current_event = event_random
            Current_event.generate_travel_options()
            new_menu = menu.new_menu(event_random)
        end
        menu.current_menu = new_menu
        Travel_anim_x = 2
        map.travel_destination = 2
        State = states.travel
    elseif string.find(v, events_options.go_to_third_room) then
        local new_menu = nil
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
            Current_event.generate_travel_options()
            new_menu = menu.new_menu(event_merchant)
        elseif string.find(v, map.door_names.combat) then
            Current_event = event_combat
            Current_event.generate_travel_options()
            new_menu = menu.new_menu(event_combat)
        elseif string.find(v, map.door_names.event) then
            Current_event = event_random
            Current_event.generate_travel_options()
            new_menu = menu.new_menu(event_random)
        end
        menu.current_menu = new_menu
        Travel_anim_x = 2
        map.travel_destination = 2
        State = states.travel
    end
end


return menu
