require "api"

local g = require "globals"

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
    F = 0
    map.generate_rooms()
    event_start.generate_travel_options()
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
            do end  -- TODO: Add dice to the current pool there!
        elseif Btnp("escape") then
            player.inventory_chosen = 1
            State = states.blank
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
            State = states.blank
        end
    elseif State == states.travel and F % 2 == 0 then
        Travel_anim_x = Travel_anim_x + g.screen.gamepixel.w
        if Travel_anim_x >= 256/2 then
            State = states.blank
            map.travel()
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
