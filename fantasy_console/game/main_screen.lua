require "../api"

local dice = require "game/dice"
local player = require "game/player"
local states = require "game/states"

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

function screen.draw_last_roll(state)
    for i, roll in ipairs(dice.last_results) do
        local side_to_show = dice.last_results[i][2]
        if state ~= states.rolling then
            if side_to_show == 6 and dice.last_results[i][1] == dice.green then
                side_to_show = 7  -- 6 with success marked
            elseif (side_to_show == 6 or side_to_show == 1) and dice.last_results[i][1] == dice.red then
                side_to_show = 7
            elseif (side_to_show == 6 or side_to_show == 2 or side_to_show == 3) and dice.last_results[i][1] == dice.gold then
                side_to_show = 7
            end
        end
        dice.draw(
            screen.dice_slots[i][1],
            screen.dice_slots[i][2],
            dice.last_results[i][1],
            side_to_show
        )
    end
end

function screen.draw_player_data()
    Write(132, 86, "Health:")
    Write(168, 86, player.current_health .. "/" .. player.max_health)
    Write(132, 96,  "Physique:")
    Write(168, 96, tostring(player.skills[1][2]))
    Write(132, 106, "Precision:")
    Write(168, 106, tostring(player.skills[2][2]))
    Write(132, 116, "Logic:")
    Write(168, 116, tostring(player.skills[3][2]))
    Write(132, 126, "Empathy:")
    Write(168, 126, tostring(player.skills[4][2]))
end

return screen
