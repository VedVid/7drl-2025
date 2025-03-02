require "../api"

local dice = require "game/dice"
local map = require "game/map"
local menu = require "game/menu"
local player = require "game/player"
local states = require "game/states"

local screen = {}

screen.dice_slots = {
    {131, 2}, {149, 2}, {167, 2}, {185, 2}, {203, 2}, {221, 2}, {239, 2},
    {131, 20}, {149, 20}, {167, 20}, {185, 20}, {203, 20}, {221, 20}, {239, 20},
    {131, 38}, {149, 38}, {167, 38}, {185, 38}, {203, 38}, {221, 38}, {239, 38}
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
    Write(132, 106, "Cunning:")
    Write(168, 106, tostring(player.skills[2][2]))
    Write(132, 116, "Empathy:")
    Write(168, 116, tostring(player.skills[3][2]))
end

function screen.draw_inventory()
    local sprites_red = {
        60, 60, 59, 58, 57, 56
    }
    local sprites_gold = {
        90, 90, 90, 89, 88, 87
    }
    local y = 85
    local y_step = 12
    for i, die in ipairs(player.inventory) do
        local x = 195
        local x_step = 10
        if State == states.inventory and i == player.inventory_chosen then
            Spr(x-x_step, y, 181)
        end
        local current_sprites
        local color
        if die == dice.red then
            current_sprites = sprites_red
            color = Red
        elseif die == dice.gold then
            current_sprites = sprites_gold
            color = Yellow
        end
        for j = 1, #current_sprites do
            Spr(x, y, current_sprites[j])
            Rect(x-1, y, 9, 9, color)
            x = x + x_step
        end
        y = y + y_step
    end
end

function screen.draw_map(state)
    local positions = {}
    local line_color = Blue
    if state == states.travel then line_color = BlueBold end
    if #map.doors_to == 1 then
        table.insert(positions, {95, 31, 15, 15})
        Line(65, 38, 95, 38, line_color)
    elseif #map.doors_to == 2 then
        table.insert(positions, {95, 15, 15, 15})
        table.insert(positions, {95, 47, 15, 15})
        Line(65, 38, 95, 22, line_color)
        Line(65, 38, 95, 54, line_color)
    elseif #map.doors_to == 3 then
        table.insert(positions, {95, 12, 15, 15})
        table.insert(positions, {95, 31, 15, 15})
        table.insert(positions, {95, 50, 15, 15})
        Line(65, 38, 95, 19, line_color)
        Line(65, 38, 95, 38, line_color)
        Line(65, 38, 95, 57, line_color)
    end
    -- Draw previous room
    if map.current_room ~= map.door_names.start then
        Pset(30, 38, Blue)
        Pset(32, 38, Blue)
        Pset(34, 38, Blue)
        Pset(36, 38, Blue)
        Pset(38, 38, Blue)
        Pset(40, 38, Blue)
        Pset(42, 38, Blue)
        Pset(44, 38, Blue)
        Pset(46, 38, Blue)
        Pset(48, 38, Blue)
        Pset(50, 38, Blue)
        Pset(52, 38, Blue)
        Pset(54, 38, Blue)
        Pset(56, 38, Blue)
        Rect(18, 32, 13, 13, White)
    end
    -- Draw current room
    Rect(55, 31, 16, 15, White)
    Rectfill(56, 32, 14, 13, WhiteBold)
    Write(61, 35, "@", Green)
    -- Draw next rooms
    for i, position in ipairs(positions) do
        Rect(
            position[1],
            position[2],
            position[3],
            position[4],
            White
        )
        if map.doors_to[i] == "merchant" then
            Spr(position[1]+4, position[2]+4, 29)
        elseif map.doors_to[i] == "event" then
            Write(position[1]+6, position[2] + 4, "?", PinkBold)
        elseif map.doors_to[i] == "combat" then
            Spr(position[1]+4, position[2]+4, 30)
        end
    end
    if State == states.travel then
        Rectfill(0, 0, Travel_anim_x, 81, Black)
    end
end

function screen.draw_menu()
    Write(3, 86, menu.current_menu.header, White)
    local y = 122
    local y_step = 10
    local x = 15
    for i, option in ipairs(menu.current_menu.options) do
        if State == states.menu and i == menu.option_chosen then
            Spr(x-12, y-1, 181)
        end
        Write(x, y, option, WhiteBold)
        y = y + y_step
    end
end


return screen
