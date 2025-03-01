require "api"

local g = require "globals"

local dice = require "game/dice"
local screen = require "game/main_screen"
local player = require "game/player"
local states = require "game/states"


function Init()
    math.randomseed(os.time())
    State = states.blank
    F = 0
    player.set_random_skills()
end


function Input()
    if Btnp("return") and State == states.blank then
        State = states.rolling
        Rolls = dice.generate_rolls({dice.green, dice.green, dice.gold}, 7)
        Current_side = 1
        dice.update_last_results()
    end
end


function Update()
    F = F + 1
    if State == states.rolling and F % 10 == 0 then
        if Current_side + 1 <= #Rolls[1] then
            Current_side = Current_side + 1
            dice.update_last_results()
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
