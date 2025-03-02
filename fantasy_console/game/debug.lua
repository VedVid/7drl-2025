local dice = require "game/dice"
local map = require "game/map"
local player = require "game/player"
local states = require "game/states"


local debug = {}

function debug.inputs()
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
            State = states.travel
            Travel_anim_x = 2
            map.travel_destination = 1
        elseif Btnp("s") then
            State = states.travel
            Travel_anim_x = 2
            map.travel_destination = 2
        elseif Btnp("d") then
            State = states.travel
            Travel_anim_x = 2
            map.travel_destination = 3
        end
    end
end

return debug
