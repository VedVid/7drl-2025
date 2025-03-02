require "api"

local g = require "globals"

local dice = require "game/dice"
local map = require "game/map"
local screen = require "game/main_screen"
local player = require "game/player"
local states = require "game/states"


function Init()
    math.randomseed(os.time())
    State = states.blank
    F = 0
    map.generate_rooms()
    player.set_random_skills()
    player.inventory = {dice.red, dice.red, dice.gold, dice.gold}
end


function Input()
    if State == states.blank then
        if Btnp("1") then
            State = states.rolling
            local dices = {}
            for i = 1, player.skills[1][2] do
                table.insert(dices, dice.green)
            end
            Rolls = dice.generate_rolls(dices, 7)
            Current_side = 1
            dice.update_last_results(Rolls, Current_side)
        elseif Btnp("2") then
            State = states.rolling
            local dices = {}
            for i = 1, player.skills[2][2] do
                table.insert(dices, dice.green)
            end
            Rolls = dice.generate_rolls(dices, 7)
            Current_side = 1
            dice.update_last_results(Rolls, Current_side)
        elseif Btnp("3") then
            State = states.rolling
            local dices = {}
            for i = 1, player.skills[3][2] do
                table.insert(dices, dice.green)
            end
            Rolls = dice.generate_rolls(dices, 7)
            Current_side = 1
            dice.update_last_results(Rolls, Current_side)
        elseif Btnp("q") then
            State = states.rolling
            local dices = {}
            for i = 1, player.skills[1][2] do
                table.insert(dices, dice.green)
            end
            pcall(table.insert, dices, player.remove_from_inventory(dice.red))
            Rolls = dice.generate_rolls(dices, 7)
            Current_side = 1
            dice.update_last_results(Rolls, Current_side)
        elseif Btnp("w") then
            State = states.rolling
            local dices = {}
            for i = 1, player.skills[2][2] do
                table.insert(dices, dice.green)
            end
            pcall(table.insert, dices, player.remove_from_inventory(dice.red))
            Rolls = dice.generate_rolls(dices, 7)
            Current_side = 1
            dice.update_last_results(Rolls, Current_side)
        elseif Btnp("e") then
            State = states.rolling
            local dices = {}
            for i = 1, player.skills[3][2] do
                table.insert(dices, dice.green)
            end
            pcall(table.insert, dices, player.remove_from_inventory(dice.gold))
            Rolls = dice.generate_rolls(dices, 7)
            Current_side = 1
            dice.update_last_results(Rolls, Current_side)
        elseif Btnp("a") then
            map.travel_to(1)
        elseif Btnp("s") then
            map.travel_to(2)
        elseif Btnp("d") then
            map.travel_to(3)
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
end
