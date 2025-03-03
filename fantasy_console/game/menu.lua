require "../api"

local actions = require "game/actions"
local dice = require "game/dice"
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
        do end -- TODO: COMBAT FIGHT
    elseif string.find(v, events_options.try_to_flee) then
        State = states.rolling
        Action = actions.fleeing
        local dices = {}
        for i = 1, player.skills[2][2] do
            table.insert(dices, dice.green)
        end
        for i, n in ipairs(player.inventory_marked_for_use) do
            if player.inventory[n] == dice.red then
                table.insert(dices, dice.red)
                player.remove_from_inventory(dice.red)
            elseif player.inventory[n] == dice.gold then
                table.insert(dices, dice.gold)
                player.remove_from_inventory(dice.gold)
            end
            player.inventory_marked_for_use = {}
        end
        Rolls = dice.generate_rolls(dices, 7)
        Current_side = 1
        dice.update_last_results(Rolls, Current_side)
        do end -- TODO: COMBAT FLEE
        --Current_event.generate_travel_options()
        --menu.current_menu = menu.new_menu(Current_event)
        --menu.current_menu.header = "You fled.\nWhere are you going to go now?"
        --menu.option_chosen = 1
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
