require "api"

local dice = require "game/dice"
local screen = require "game/main_screen"


function Init()
    roll1 = dice.generate_rolls(7)
    roll2 = dice.generate_rolls(7)
    dice.zero_last_results()
    dice.add_to_last_results(roll1[#roll1], dice.green)
    dice.add_to_last_results(roll2[#roll2], dice.green)
end


function Input()
    do end
end


function Update()
    do end
end


function Draw()
    screen.draw_dividers()
    screen.draw_last_roll()
end
