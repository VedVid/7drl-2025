require "api"

local dice = require "game/dice"
local screen = require "game/main_screen"


function Init()
    no = 1
    f = 1
    roll1 = dice.generate_rolls(7)
    roll2 = dice.generate_rolls(7)
end


function Input()
    do end
end


function Update()
    f = f + 1
    if no >= 7 then return end
    if f % 10 == 0 then
      no = no + 1
    end
end


function Draw()
    screen.draw_dividers()
    dice.draw(4, 4, dice.green, roll1[no])
    dice.draw(4+16+2, 4, dice.green, roll2[no])
end
