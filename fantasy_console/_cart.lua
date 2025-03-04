require "api"

local g = require "globals"

local actions = require "game/actions"
local debug = require "game/debug"
local dice = require "game/dice"
local event_start = require "game/event_start"
local event_combat = require "game/event_combat"
local events_options = require "game/events_options"
local map = require "game/map"
local menu = require "game/menu"
local screen = require "game/main_screen"
local player = require "game/player"
local states = require "game/states"


function Init()
    Debug = true
    math.randomseed(os.time())
    State = states.menu
    Action = actions.waiting
    Base_difficulty = 1
    Difficulty = 1
    F = 0
    map.generate_rooms()
    Current_event = event_start
    Current_event.generate_travel_options()
    menu.current_menu = menu.new_menu(event_start)
    player.set_random_skills()
    player.inventory = {dice.red, dice.red, dice.red, dice.red, dice.red, dice.red, dice.gold, dice.gold}
end

function Input()
    if Debug then
        debug.inputs()
    end
    if State == states.inventory then
        if Btnp("up") then
            player.inventory_chosen = player.inventory_chosen - 1
            if player.inventory_chosen < 1 then
                player.inventory_chosen = #player.inventory
            end
        elseif Btnp("down") then
            player.inventory_chosen = player.inventory_chosen + 1
            if player.inventory_chosen > #player.inventory then
                player.inventory_chosen = 1
            end
        elseif Btnp("return") then
            player.handle_dice_marking()
        elseif Btnp("escape") or Btnp("left") then
            player.inventory_chosen = 1
            State = states.menu
        end
    elseif State == states.menu then
        if Btnp("up") then
            menu.option_chosen = menu.option_chosen - 1
            if menu.option_chosen < 1 then
                menu.option_chosen = #menu.current_menu.options
            end
            player.inventory_marked_for_use = {}
        elseif Btnp("down") then
            menu.option_chosen = menu.option_chosen + 1
            if menu.option_chosen > #menu.current_menu.options then
                menu.option_chosen = 1
            end
            player.inventory_marked_for_use = {}
        elseif Btnp("return") then
            menu.choose_option()
        elseif Btnp("right") then
            if events_options.lookup_with_dice[menu.current_menu.options[menu.option_chosen]] then
                State = states.inventory
            end
        end
    end
end


function Update()
    F = F + 1
    if State == states.rolling and F % 10 == 0 then
        if Current_side + 1 <= #Rolls[1][2] then
            Current_side = Current_side + 1
            dice.update_last_results(Rolls, Current_side)
        else
            State = states.menu
        end
    elseif State == states.travel and F % 2 == 0 then
        Travel_anim_x = Travel_anim_x + g.screen.gamepixel.w
        if Travel_anim_x >= 256/2 then
            map.travel()
            State = states.menu
            menu.option_chosen = 1
            menu.current_menu = menu.new_menu(Current_event)
        end
    elseif State == states.menu then
        if Action == actions.fleeing then
            if dice.check_for_success(1) == true then
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "You managed to escape.\nWhere are you going to go now?"
                menu.option_chosen = 1
            else
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                player.current_health = player.current_health - 1
                menu.current_menu.header = "You managed to escape, but not unscathed.\nWhere are you going to go now?"
                menu.option_chosen = 1
            end
            Difficulty = Base_difficulty
            Action = actions.waiting
        elseif Action == actions.fighting then
            if dice.check_for_success(1) == true then
                local loot_string = event_combat.grant_rewards()
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "You defeated the opponents.\n" .. loot_string .. "\nWhere are you going to go now?"
                menu.option_chosen = 1
                Difficulty = Base_difficulty
            else
                player.current_health = player.current_health - 1
                menu.current_menu.header = "You have been hit.\nWhat do you do?"
            end
            Action = actions.waiting
        elseif Action == actions.diplomacy then
            if dice.check_for_success(1) == true then
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "You talked your way out of it.\nWhere are you going to go now?"
                menu.option_chosen = 1
                Difficulty = Base_difficulty
            else
                -- TODO: INCREASE DIFFICULTY OF OTHER TESTS
                Current_event.options = {"Fight", "Try to flee"}
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "Your persuasion attempts failed.\nPeace is no longer on the table."
                menu.option_chosen = 1
                Difficulty = Difficulty + 1
            end
            Action = actions.waiting
        end
    end
    if F > 3000 then
        F = 0
    end
end


function Draw()
    screen.draw_dividers()
    screen.draw_map()
    screen.draw_last_roll(State)
    screen.draw_player_data()
    screen.draw_inventory()
    screen.draw_menu()
end
