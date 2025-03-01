require "api"

local g = require "globals"

local dice = require "game/dice"
local screen = require "game/main_screen"
local states = require "game/states"


function Init()
    State = states.blank
    F = 0
end


function Input()
    if Btnp("return") and State == states.blank then
        State = states.rolling
        Rolls = dice.generate_rolls(4, 7)
        Current_side = 1
        dice.update_last_results(Rolls, Current_side, dice.green)
    end
end


function Update()
    F = F + 1
    if State == states.rolling and F % 10 == 0 then
        if Current_side + 1 <= #Rolls[1] then
            Current_side = Current_side + 1
            dice.update_last_results(Rolls, Current_side, dice.green)
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
end
