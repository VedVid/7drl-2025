require "../api"

local actions = require "game/actions"
local event_combat = require "game/event_combat"
local event_merchant = require "game/event_merchant"
local event_random = require "game/event_random"
local events_options = require "game/events_options"
local map = require "game/map"
local player = require "game/player"
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
        Current_event.options = Current_event.base_options
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
        elseif string.find(v, map.door_names.combat) then
            Current_event = event_combat
        elseif string.find(v, map.door_names.event) then
            Current_event = event_random
        end
    elseif string.find(v, events_options.go_to_second_room) then
        State = states.travel
        Travel_anim_x = 2
        map.travel_destination = 2
        Current_event.options = Current_event.base_options
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
        elseif string.find(v, map.door_names.combat) then
            Current_event = event_combat
        elseif string.find(v, map.door_names.event) then
            Current_event = event_random
        end
    elseif string.find(v, events_options.go_to_third_room) then
        State = states.travel
        Travel_anim_x = 2
        map.travel_destination = 3
        Current_event.options = Current_event.base_options
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
        elseif string.find(v, map.door_names.combat) then
            Current_event = event_combat
        elseif string.find(v, map.door_names.event) then
            Current_event = event_random
        end
    elseif string.find(v, events_options.purchase) then
        do end -- TODO: MERCHANT PURCHASE
    elseif string.find(v, events_options.sell) then
        do end -- TODO: MERCHANT SELL
    elseif string.find(v, events_options.steal_from) then
        do end -- TODO: MERCHANT PICKPOCKET
    elseif string.find(v, events_options.leave) then
        Current_event.generate_travel_options()
        menu.current_menu = menu.new_menu(Current_event)
        menu.current_menu.header = "You left the merchant.\nWhere are you going to go now?"
        menu.option_chosen = 1
    elseif string.find(v, events_options.fight) then
        player.make_a_roll(actions.fighting)
    elseif string.find(v, events_options.try_to_flee) then
        player.make_a_roll(actions.fleeing)
    elseif string.find(v, events_options.try_diplomacy) then
        do end -- TODO: COMBAT DIPLOMACY
    elseif string.find(v, events_options.proceed) then
        Current_event.generate_travel_options()
        menu.current_menu = menu.new_menu(Current_event)
        menu.current_menu.header = "Event finished.\nWhere are you going to go now?"
        menu.option_chosen = 1
    end
end


return menu
