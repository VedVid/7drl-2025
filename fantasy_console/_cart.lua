require "api"

local debug = require "game/debug"
local dice = require "game/dice"
local map = require "game/map"
local screen = require "game/main_screen"
local player = require "game/player"
local states = require "game/states"


function Init()
    Debug = true
    math.randomseed(os.time())
    State = states.blank
    F = 0
    map.generate_rooms()
    player.set_random_skills()
    player.inventory = {dice.red, dice.red, dice.gold, dice.gold}
end

function Input()
    if Debug then
        debug.inputs()
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
