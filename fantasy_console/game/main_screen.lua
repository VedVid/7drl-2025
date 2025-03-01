require "../api"

local dice = require "game/dice"

local screen = {}

screen.dice_slots = {
    {130, 2}, {148, 2}, {166, 2}, {184, 2}, {200, 2}, {218, 2},
    {130, 20}, {148, 20}, {166, 20}, {184, 20}, {200, 20}, {218, 20},
    {130, 38}, {148, 38}, {166, 38}, {184, 38}, {200, 38}, {218, 38}
}

function screen.draw_dividers()
    Line(256/2, 0, 256/2, 192, BlackBold)
    Line(0, (192/2)-15, 256, (192/2)-15, BlackBold)
end

function screen.draw_last_roll()
    for i, side in ipairs(dice.last_results) do
        dice.draw(
            screen.dice_slots[i][1],
            screen.dice_slots[i][2],
            dice.last_results_die,
            side
        )
    end
end

return screen
