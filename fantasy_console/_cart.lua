require "api"

local g = require "globals"

local actions = require "game/actions"
local debug = require "game/debug"
local dice = require "game/dice"
local event_start = require "game/event_start"
local event_combat = require "game/event_combat"
local event_merchant = require "game/event_merchant"
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
    Room = 1
    Base_difficulty = 1
    Difficulty = 1
    Stole_already = false
    F = 0
    map.generate_rooms()
    Current_event = event_start
    Current_event.generate_travel_options()
    menu.current_menu = menu.new_menu(event_start)
    player.set_random_skills()
    player.inventory = {dice.red, dice.gold}
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
    elseif State == states.purchasing or State == states.stealing then
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
        end
    end
end


function Update()
    F = F + 1
    if State == states.rolling and F % 5 == 0 then
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
            if dice.check_for_success(Difficulty) == true then
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "You managed to escape.\nWhere are you going to go now?"
                menu.option_chosen = 1
            else
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                player.current_health = player.current_health - 1
                menu.current_menu.header = "You managed to escape,\nbut not unscathed.\nWhere are you going to go now?"
                menu.option_chosen = 1
            end
            Difficulty = Base_difficulty
            Action = actions.waiting
        elseif Action == actions.fighting then
            if dice.check_for_success(Difficulty) == true then
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
            if dice.check_for_success(Difficulty) == true then
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "You talked your way out of it.\nWhere are you going to go now?"
                menu.option_chosen = 1
                Difficulty = Base_difficulty
            else
                Current_event.options = {"Fight", "Try to flee"}
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "Your persuasion attempts failed.\nPeace is no longer on the table."
                menu.option_chosen = 1
                Difficulty = Difficulty + 1
            end
            Action = actions.waiting
        elseif Action == actions.stealing then
            if dice.check_for_success(Difficulty) == true then
                State = states.stealing
                Difficulty = Difficulty + 1
                Current_event.generate_purchasing_options()
                Current_event.options = Current_event.purchasing_options
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "You've distracted the merchant.\nWhat item do you want to steal?"
                if menu.option_chosen > #menu.current_menu.options then
                    menu.option_chosen = #menu.current_menu.options
                end
            else
                event_merchant.angry = true
                event_merchant.increase_prices(0.3)
                State = states.menu
                menu.current_menu.header = "You have been caught red handed.\nMerchant is furious and will\nnot trade with you anymore.\nGuild increases prices for you."
            end
            Action = actions.waiting
        elseif Action == actions.searching_pockets then
            if dice.check_for_success(Difficulty) == true then
                local chances = math.random(101)
                if chances <= 50 or #player.inventory >= player.inventory_max then
                    player.gold = player.gold + math.ceil(math.random(10 * Difficulty) * event_merchant.price_modifier)
                    Current_event.generate_travel_options()
                    menu.current_menu = menu.new_menu(Current_event)
                    menu.current_menu.header = "You found some coins.\nWhere are you going to go now?"
                else
                    local dices = {dice.red, dice.gold}
                    player.add_to_inventory(dices[math.random(#dices)])
                    Current_event.generate_travel_options()
                    menu.current_menu = menu.new_menu(Current_event)
                    menu.current_menu.header = "You found a die.\nWhere are you going to go now?"
                end
            else
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "You found nothing interesting.\nWhere are you going to go now?"
            end
            menu.option_chosen = 1
            Action = actions.waiting
        elseif Action == actions.help_smaller then
            if dice.check_for_success(Difficulty) == true then
                if #player.inventory < player.inventory_max - 1 then
                    local dices = {dice.red, dice.gold}
                    player.add_to_inventory(dices[math.random(#dices)])
                    player.add_to_inventory(dices[math.random(#dices)])
                    Current_event.generate_travel_options()
                    menu.current_menu = menu.new_menu(Current_event)
                    menu.current_menu.header = "Together you managed to drive\nthe larger group off.\nThey gave you two dice as a reward.\nWhere are you going to go now?"
                else
                    local gold = math.random(40, 80)
                    player.gold = player.gold + gold
                    Current_event.generate_travel_options()
                    menu.current_menu = menu.new_menu(Current_event)
                    menu.current_menu.header = "Together you managed to drive\nthe larger group off.\nThey gave a large pouch of gold.\nWhere are you going to go now?"
                end
            else
                player.current_health = player.current_health - 2
                -- TODO: show game over if you died there
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "There were too many enemies and\nyou could not drive them away...\nYou are all bruised up.\nWhere are you going to go now?"
            end
            menu.option_chosen = 1
            Action = actions.waiting
        elseif Action == actions.help_larger then
            if dice.check_for_success(Difficulty) == true then
                if #player.inventory < player.inventory_max then
                    local dices = {dice.red, dice.gold}
                    player.add_to_inventory(dices[math.random(#dices)])
                    Current_event.generate_travel_options()
                    menu.current_menu = menu.new_menu(Current_event)
                    menu.current_menu.header = "Together you crushed the opponents.\nVictors tossed you a die.\nWhere are you going to go now?"
                else
                    local gold = math.random(math.floor(20 * event_merchant.price_modifier), math.ceil(40 * event_merchant.price_modifier))
                    player.gold = player.gold + gold
                    Current_event.generate_travel_options()
                    menu.current_menu = menu.new_menu(Current_event)
                    menu.current_menu.header = "Together you crushed the opponents.\nVictors tossed you a pouch of gold.\nWhere are you going to go now?"
                end
            else
                player.current_health = player.current_health - 1
                -- TODO: show game over if you died there
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "The opponents fought very bravely\nand managed to drive you away.\nYou are slightly bruised.\nWhere are you going to go now?"
            end
            menu.option_chosen = 1
            Action = actions.waiting
        elseif Action == actions.try_to_mediate then
            if dice.check_for_success(Difficulty) == true then
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "You helped to resolve their conflict.\n"
                local chances = math.random(500)
                if chances <= 100 and #player.inventory < player.inventory_max then
                    player.add_to_inventory(dice.red)
                    menu.current_menu.header = menu.current_menu.header .. "They gratefully gave you a red die\nWhere are you going to go now?"
                elseif chances <= 200 and #player.inventory < player.inventory_max then
                    player.add_to_inventory(dice.gold)
                    menu.current_menu.header = menu.current_menu.header .. "They gratefully gave you a gold die\nWhere are you going to go now?"
                elseif chances <= 300 then
                    local gold = math.random(math.floor(10 * event_merchant.price_modifier), math.ceil(50 * event_merchant.price_modifier))
                    player.gold = player.gold + gold
                    menu.current_menu.header = menu.current_menu.header .. "They gave you a pouch of gold\nWhere are you going to go now?"
                elseif chances <= 400 then
                    if player.current_health < player.max_health then
                        player.current_health = player.current_health + 1
                    else
                        player.max_health = player.max_health + 1
                        player.current_health = player.max_health
                    end
                    menu.current_menu.header = menu.current_menu.header .. "They gace you a large ration.\nWhere are you going to go now?"
                else
                    if Base_difficulty > 1 then
                        Base_difficulty = Base_difficulty - 1
                        menu.current_menu.header = menu.current_menu.header .. "They gave you a pouch of gold\nWhere are you going to go now?"
                    else
                        local gold = math.random(math.floor(10 * event_merchant.price_modifier), math.ceil(50 * event_merchant.price_modifier))
                        player.gold = player.gold + gold
                        menu.current_menu.header = menu.current_menu.header .. "They gave you a pouch of gold\nWhere are you going to go now?"
                    end
                end
            else
                Current_event.generate_travel_options()
                menu.current_menu = menu.new_menu(Current_event)
                menu.current_menu.header = "They kept arguing louder and louder,\nand you started feeling unwell.\nWhere are you going to go now?"
                player.current_health = player.current_health - 1
            end
            menu.option_chosen = 1
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
