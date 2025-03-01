require "api"

local g = require "globals"

local dice = require "game/dice"
local screen = require "game/main_screen"
local player = require "game/player"
local states = require "game/states"
local utils = require "game/utils"


function Init()
    math.randomseed(os.time())
    State = states.blank
    F = 0
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
        elseif Btnp("4") then
            State = states.rolling
            local dices = {}
            for i = 1, player.skills[4][2] do
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
            if utils.has_value(player.inventory, dice.red) then
                table.insert(dices, dice.red)
            end
            Rolls = dice.generate_rolls(dices, 7)
            Current_side = 1
            dice.update_last_results(Rolls, Current_side)
        elseif Btnp("w") then
            State = states.rolling
            local dices = {}
            for i = 1, player.skills[2][2] do
                table.insert(dices, dice.green)
            end
            if utils.has_value(player.inventory, dice.red) then
                table.insert(dices, dice.red)
            end
            Rolls = dice.generate_rolls(dices, 7)
            Current_side = 1
            dice.update_last_results(Rolls, Current_side)
        elseif Btnp("e") then
            State = states.rolling
            local dices = {}
            for i = 1, player.skills[3][2] do
                table.insert(dices, dice.green)
            end
            if utils.has_value(player.inventory, dice.gold) then
                table.insert(dices, dice.gold)
            end
            Rolls = dice.generate_rolls(dices, 7)
            Current_side = 1
            dice.update_last_results(Rolls, Current_side)
        elseif Btnp("r") then
            State = states.rolling
            local dices = {}
            for i = 1, player.skills[4][2] do
                table.insert(dices, dice.green)
            end
            if utils.has_value(player.inventory, dice.gold) then
                table.insert(dices, dice.gold)
            end
            Rolls = dice.generate_rolls(dices, 7)
            Current_side = 1
            dice.update_last_results(Rolls, Current_side)
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
    screen.draw_last_roll(State)
    screen.draw_player_data()
end
