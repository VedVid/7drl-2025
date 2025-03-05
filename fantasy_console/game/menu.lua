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
        Stole_already = false
        Room = Room + 1
        if Room % 10 == 0 then
            Base_difficulty = Base_difficulty + 1
            event_merchant.increase_prices(0.1)
        end
        Difficulty = Base_difficulty
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
            Current_event.generate_inventory()
        elseif string.find(v, map.door_names.combat) then
            Current_event = event_combat
        elseif string.find(v, map.door_names.event) then
            Current_event = event_random
            Current_event.choose_and_update_event()
        end
    elseif string.find(v, events_options.go_to_second_room) then
        State = states.travel
        Travel_anim_x = 2
        map.travel_destination = 2
        Current_event.options = Current_event.base_options
        Stole_already = false
        Room = Room + 1
        if Room % 10 == 0 then
            Base_difficulty = Base_difficulty + 1
            event_merchant.increase_prices(0.1)
        end
        Difficulty = Base_difficulty
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
            Current_event.generate_inventory()
        elseif string.find(v, map.door_names.combat) then
            Current_event = event_combat
        elseif string.find(v, map.door_names.event) then
            Current_event = event_random
            Current_event.choose_and_update_event()
        end
    elseif string.find(v, events_options.go_to_third_room) then
        State = states.travel
        Travel_anim_x = 2
        map.travel_destination = 3
        Current_event.options = Current_event.base_options
        Stole_already = false
        Room = Room + 1
        if Room % 10 == 0 then
            Base_difficulty = Base_difficulty + 1
            event_merchant.increase_prices(0.1)
        end
        Difficulty = Base_difficulty
        if string.find(v, map.door_names.merchant) then
            Current_event = event_merchant
            Current_event.generate_inventory()
        elseif string.find(v, map.door_names.combat) then
            Current_event = event_combat
        elseif string.find(v, map.door_names.event) then
            Current_event = event_random
            Current_event.choose_and_update_event()
        end
    ---
    --- MERCHANT
    --- 
    elseif string.find(v, events_options.purchase) then
        if event_merchant.angry == false then
            State = states.purchasing
            Current_event.generate_purchasing_options()
            Current_event.options = Current_event.purchasing_options
            menu.current_menu = menu.new_menu(Current_event)
            menu.current_menu.header = "Merchant is showing you the wares."
            menu.option_chosen = 1
        end
    elseif string.find(v, events_options.go_back) then
        State = states.menu
        Current_event.options = Current_event.base_options
        menu.current_menu = menu.new_menu(Current_event)
        menu.current_menu.header = Current_event.header
        menu.option_chosen = 1
    elseif State == states.purchasing then
        if event_merchant.check_if_in_inventory(v) then
            event_merchant.player_purchase_from_merchant(menu.option_chosen)
        end
        Current_event.generate_purchasing_options()
        Current_event.options = Current_event.purchasing_options
        menu.current_menu = menu.new_menu(Current_event)
        menu.current_menu.header = "Merchant is showing you the wares."
        if menu.option_chosen > #menu.current_menu.options then
            menu.option_chosen = #menu.current_menu.options
        end
    elseif string.find(v, events_options.steal_from) then
        if event_merchant.angry == false then
            State = states.stealing
            Stole_already = false
            player.make_a_roll(actions.stealing, events_options.lookup_with_dice[events_options.steal_from])
        end
    elseif State == states.stealing then
        if Stole_already == false then
            if event_merchant.check_if_in_inventory(v) then
                event_merchant.player_purchase_from_merchant(menu.option_chosen)
                Stole_already = true
            end
            Current_event.generate_purchasing_options()
            Current_event.options = Current_event.purchasing_options
            menu.current_menu = menu.new_menu(Current_event)
            if Action == actions.stealing then
                menu.current_menu.header = "You've distracted the merchant.\nWhat item do you want to steal?"
            else
                menu.current_menu.header = "You quickly grab an item and hide it.\nMerchant becomes more alert."
            end
            if menu.option_chosen > #menu.current_menu.options then
                menu.option_chosen = #menu.current_menu.options
            end
        end
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
    else
        if string.find(v, event_random.free_meal.options[1]) then
            if player.current_health < player.max_health then
                player.current_health = player.current_health + 1
            else
                player.max_health = player.max_health + 1
                player.current_health = player.max_health
            end
            Current_event.generate_travel_options()
            menu.current_menu = menu.new_menu(Current_event)
            menu.current_menu.header = "You feel better.\nWhere are you going to go now?"
            menu.option_chosen = 1
        elseif string.find(v, event_random.decrease_danger.options[1]) then
            Base_difficulty = Base_difficulty - 1
            if Base_difficulty <= 0 then
                Base_difficulty = 1
            end
            Difficulty = Base_difficulty
            Current_event.generate_travel_options()
            menu.current_menu = menu.new_menu(Current_event)
            menu.current_menu.header = "You feel safer already.\nWhere are you going to go now?"
            menu.option_chosen = 1
        elseif string.find(v, event_random.fresh_corpse.options[1]) then
            player.make_a_roll(actions.searching_pockets, events_options.lookup_with_dice[events_options.search_pockets])
        elseif string.find(v, event_random.fresh_corpse.options[2]) then
            Current_event.generate_travel_options()
            menu.current_menu = menu.new_menu(Current_event)
            menu.current_menu.header = "You decided to leave.\nWhere are you going to go now?"
            menu.option_chosen = 1
        elseif string.find(v, event_random.infighting[1]) then
            player.make_a_roll(actions.help_smaller, events_options.lookup_with_dice[events_options.help_smaller_group])
        elseif string.find(v, event_random.infighting[2]) then
            player.make_a_roll(actions.help_larger, events_options.lookup_with_dice[events_options.help_larger_group])
        elseif string.find(v, event_random.infighting[3]) then
            Current_event.generate_travel_options()
            menu.current_menu = menu.new_menu(Current_event)
            menu.current_menu.header = "You sneaked away before\nanyone noticed you.\nWhere are you going to go now?"
            menu.option_chosen = 1
        end
    end
end


return menu
