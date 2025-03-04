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
    ---
    --- TRAVEL
    --- 
    if string.find(v, events_options.go_to_first_room) then
        State = states.travel
        Travel_anim_x = 2
        map.travel_destination = 1
        Current_event.options = Current_event.base_options
        Difficulty = Base_difficulty
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
            Current_event.generate_inventory()
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
        Difficulty = Base_difficulty
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
            Current_event.generate_inventory()
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
        Difficulty = Base_difficulty
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
            Current_event.generate_inventory()
        elseif string.find(v, map.door_names.combat) then
            Current_event = event_combat
        elseif string.find(v, map.door_names.event) then
            Current_event = event_random
        end
    ---
    --- MERCHANT
    --- 
    elseif string.find(v, events_options.purchase) then
        State = states.purchasing
        Current_event.generate_purchasing_options()
        Current_event.options = Current_event.purchasing_options
        menu.current_menu = menu.new_menu(Current_event)
        menu.current_menu.header = "Merchant is showing you the wares."
        menu.option_chosen = 1
    elseif string.find(v, events_options.go_back) then
        State = states.menu
        Current_event.options = Current_event.base_options
        menu.current_menu = menu.new_menu(Current_event)
        menu.current_menu.header = Current_event.header
        menu.option_chosen = 1
    elseif State == states.purchasing then
        print("State == purchasing")
        if event_merchant.check_if_in_inventory(v) then
            print(v)
            event_merchant.player_purchase_from_merchant(menu.option_chosen)
        end
    elseif string.find(v, events_options.sell) then
        do end -- TODO: MERCHANT SELL
    elseif string.find(v, events_options.steal_from) then
        do end -- TODO: MERCHANT PICKPOCKET
    elseif string.find(v, events_options.leave) then
        Current_event.reset()
        Current_event.generate_travel_options()
        menu.current_menu = menu.new_menu(Current_event)
        menu.current_menu.header = "You left the merchant.\nWhere are you going to go now?"
        menu.option_chosen = 1
    ---
    --- COMBAT
    ---
    elseif string.find(v, events_options.fight) then
        player.make_a_roll(actions.fighting, events_options.lookup_with_dice[events_options.fight])
    elseif string.find(v, events_options.try_to_flee) then
        player.make_a_roll(actions.fleeing, events_options.lookup_with_dice[events_options.try_to_flee])
    elseif string.find(v, events_options.try_diplomacy) then
        player.make_a_roll(actions.diplomacy, events_options.lookup_with_dice[events_options.try_diplomacy])
    ---
    --- RANDOM EVENTS
    ---
    elseif string.find(v, events_options.proceed) then
        Current_event.generate_travel_options()
        menu.current_menu = menu.new_menu(Current_event)
        menu.current_menu.header = "Event finished.\nWhere are you going to go now?"
        menu.option_chosen = 1
    end
end


return menu
