require "api"

local g = require "globals"

local actions = require "game/actions"
local debug = require "game/debug"
local dice = require "game/dice"
local event_start = require "game/event_start"
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
        elseif Btnp("down") then
            menu.option_chosen = menu.option_chosen + 1
            if menu.option_chosen > #menu.current_menu.options then
                menu.option_chosen = 1
            end
        elseif Btnp("return") then
            menu.choose_option()
        elseif Btnp("right") then
            State = states.inventory
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
    elseif State == states.menu and Action == actions.fleeing then
        if dice.check_for_success() == true then
            Current_event.generate_travel_options()
            menu.current_menu = menu.new_menu(Current_event)
            menu.current_menu.header = "You managed to escape.\nWhere are you going to go now?"
            menu.option_chosen = 1
        else
            player.current_health = player.current_health - 1
            menu.current_menu.header = "You failed to escape.\nYou have been hit.\nWhat do you do?"
        end
        Action = actions.waiting
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
