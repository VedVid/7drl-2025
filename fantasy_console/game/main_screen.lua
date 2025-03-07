require "../api"

local g = require "globals"

local actions = require "game/actions"
local dice = require "game/dice"
local event_merchant = require "game/event_merchant"
local events_options = require "game/events_options"
local map = require "game/map"
local menu = require "game/menu"
local player = require "game/player"
local states = require "game/states"
local utils = require "game/utils"

local screen = {}

screen.dice_slots = {
    {131, 2}, {149, 2}, {167, 2}, {185, 2}, {203, 2}, {221, 2}, {239, 2},
    {131, 20}, {149, 20}, {167, 20}, {185, 20}, {203, 20}, {221, 20}, {239, 20},
    {131, 38}, {149, 38}, {167, 38}, {185, 38}, {203, 38}, {221, 38}, {239, 38}
}

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

function screen.draw_roll_preview(option)
    do end
end

function screen.draw_player_data()
    Write(132, 86, "Health:", White)
    Write(168, 86, player.current_health .. "/" .. player.max_health, White)
    local lookup = events_options.lookup_with_dice[menu.current_menu.options[menu.option_chosen]]
    if lookup then lookup = lookup[1] end
    if lookup == "physique" then
        Write(132, 96,  "Physique:", GreenBold)
        Write(168, 96, tostring(player.skills[1][2]), GreenBold)
        Spr(174, 95, 120)
        Rect(173, 95, 9, 9, Green)
    else
        Write(132, 96,  "Physique:", White)
        Write(168, 96, tostring(player.skills[1][2]), White)
    end
    if lookup == "cunning" then
        Write(132, 106, "Cunning:", GreenBold)
        Write(168, 106, tostring(player.skills[2][2]), GreenBold)
        Spr(174, 105, 120)
        Rect(173, 105, 9, 9, Green)
    else
        Write(132, 106, "Cunning:", White)
        Write(168, 106, tostring(player.skills[2][2]), White)
    end
    if lookup == "empathy" then
        Write(132, 116, "Empathy:", GreenBold)
        Write(168, 116, tostring(player.skills[3][2]), GreenBold)
        Spr(174, 115, 120)
        Rect(173, 115, 9, 9, Green)
    else
        Write(132, 116, "Empathy:", White)
        Write(168, 116, tostring(player.skills[3][2]), White)
    end
    Write(132, 126, "Gold:", White)
    Write(168, 126, tostring(player.gold), White)
    Write(132, 136, "Room:", White)
    Write(168, 136, tostring(Room), White)
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
        local x = 194
        local x_step = 10
        if State == states.inventory and i == player.inventory_chosen then
            Spr(x-x_step, y, 181)
        end
        if utils.has_value(player.inventory_marked_for_use, i) then
            Pset(253, y+4, Pink)
            Pset(254, y+3, Pink)
            Pset(254, y+5, Pink)
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
        Rect(18, 32, 13, 13, BlackBold)
    end
    -- Draw current room
    Rect(55, 31, 16, 15, BlackBold)
    Rectfill(56, 32, 14, 13, WhiteBold)
    Write(61, 35, "@", Green)
    -- Draw next rooms
    for i, position in ipairs(positions) do
        Rect(
            position[1],
            position[2],
            position[3],
            position[4],
            BlackBold
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
        if (State == states.menu or State == states.purchasing or State == states.stealing) and i == menu.option_chosen then
            Spr(x-12, y-1, 181)
        end
        local color = White
        if State == states.purchasing and string.find(option, "%]") then
            local ss1 = Split(option, "]")
            local ss2
            local price
            for _, s in ipairs(ss1) do
                if string.find(s, "$") then
                    ss2 = Split(s, "%[")
                    if #ss2 >= 2 then
                        price = Sub(ss2[2], 1, #ss2[2]-2)
                    end
                end
            end
            if tonumber(price) > player.gold then
                color = BlackBold
            end
        end
        if State == states.stealing then
            if option ~= "Go back" and Stole_already == true then
                color = BlackBold
            end
        end
        if Current_event == event_merchant then
            if Current_event.angry == true and option ~= "Leave" then
                color = BlackBold
            end
        end
        if events_options.lookup_with_dice[menu.current_menu.options[i]] then
            Write(x, y, option .. " [#" .. Difficulty .. "]", color)
        else
            Write(x, y, option, color)
        end
        y = y + y_step
    end
end

function screen.draw_main_menu()
    local ystep = 5
    --Write(10, 10,             "     :::    :::       ::::    :::       ::::::::      :::    :::       :::::::::       :::::::::: ", YellowBold)
    Write(31, 15,             "     ...    ...       ....    ...       ........      ...    ...       .........       .......... ", YellowBold)
    Write(31, 15+ystep,       "    :::    :::       :::::   :::      :::    :::     :::    :::       :::    :::      :::         ", Yellow)
    Write(31, 15+(ystep * 2), "   :::    :::       ::::::  :::      :::            :::    :::       :::    :::      :::          ", Yellow)
    Write(31, 15+(ystep * 3), "  :::    :::       ::: ::: :::      ::::::::::     :::    :::       :::::::::       ::::::::      ", Yellow)
    Write(31, 15+(ystep * 4), " :::    :::       :::  ::::::             :::     :::    :::       :::    :::      :::            ", Yellow)
    Write(31, 15+(ystep * 5), ":::    :::       :::   :::::      :::    :::     :::    :::       :::    :::      :::             ", Yellow)
    Write(31, 15+(ystep * 6), ";;;;;;;;;;       ;;;   ;;;;;      ;;;;;;;;;;     ;;;;;;;;;;       ;;;    ;;;      ;;;;;;;;;       ", Red)
    Spr(80-12, 89 + (8 * (menu.option_chosen - 1)), 181)
    Write(80, 90, "Start new game")
    Write(80, 98, "Play tutorial game")
    Write(80, 106, "Show high scores")
    Write(80, 114, "Quit game")
    Write(80, 184, "7DRL 2025 entry by Tomasz \"VedVid\" Nowakowski", BlackBold)
end

function screen.draw_game_over_screen()
    local ystep = 5
    Write(56, 10,              "      ........           ...          ...   ...       .......... ", YellowBold)
    Write(56, 10+ystep,        "    :::    :::        ::: :::       ::::: :::::      :::         ", Yellow)
    Write(56, 10+(ystep * 2),  "   :::              :::   :::     ::: ::::: :::     :::          ", Yellow)
    Write(56, 10+(ystep * 3),  "  :::             :::::::::::    :::  :::  :::     ::::::::      ", Yellow)
    Write(56, 10+(ystep * 4),  " :::   ::::      :::     :::    :::       :::     :::            ", Yellow)
    Write(56, 10+(ystep * 5),  ":::    :::      :::     :::    :::       :::     :::             ", Yellow)
    Write(56, 10+(ystep * 6),  ";;;;;;;;;;      ;;;     ;;;    ;;;       ;;;     ;;;;;;;;;;      ", Red)
    Write(56, 12+(ystep * 7),  "      ........    ...     ...       ..........       .........   ", YellowBold)
    Write(56, 12+(ystep * 8),  "    :::    :::   :::     :::       :::              :::    :::   ", Yellow)
    Write(56, 12+(ystep * 9),  "   :::    :::   :::     :::       :::              :::    :::    ", Yellow)
    Write(56, 12+(ystep * 10), "  :::    :::   :::     :::       ::::::::         :::::::::      ", Yellow)
    Write(56, 12+(ystep * 11), " :::    :::    :::   :::        :::              :::    :::      ", Yellow)
    Write(56, 12+(ystep * 12), ":::    :::     :::::::         :::              :::    :::       ", Yellow)
    Write(56, 12+(ystep * 13), ";;;;;;;;;;     ;;;;;;;         ;;;;;;;;;;       ;;;    ;;;       ", Red)
    Write(60, 94, "You died at " .. Room .. " room.")
    Write(60, 106, "You character had the following skills:")
    Write(64, 116, "Physique:")
    Write(100, 116, tostring(player.skills[1][2]))
    Write(64, 126, "Cunning:")
    Write(100, 126, tostring(player.skills[2][2]))
    Write(64, 136, "Empathy:")
    Write(100, 136, tostring(player.skills[3][2]))
    Write(60, 148, "You gathered " .. player.gold .. " gold pieces.")
    local red_dice = 0
    local gold_dice = 0
    for _, v in ipairs(player.inventory) do
        if v == dice.red then
            red_dice = red_dice + 1
        elseif v == dice.gold then
            gold_dice = gold_dice + 1
        end
    end
    local s = "You had"
    ystep = 12
    if red_dice <= 0 and gold_dice <= 0 then
        s = s .. " no dice in the inventory in the moment you died."
    else
        ystep = ystep + ystep - 4
        if red_dice >= 1 and gold_dice <= 0 then
            s = s .. " " .. red_dice .. "x red die in the inventory\nin the moment you died."
        elseif red_dice <= 0 and gold_dice >= 1 then
            s = s .. " " .. gold_dice .. "x gold die in the inventory\nin the moment you died."
        else
            s = s .. " " .. red_dice .. "x red die and " .. gold_dice .. " x gold die\nin the inventory in the moment you died."
        end
    end
    Write(60, 160, s)
    local score = math.ceil(Room + Base_difficulty + ((player.max_health + player.current_health) / 2) + player.skills[1][2] + player.skills[2][2] + player.skills[3][2] + player.gold)
    if Action == actions.add_to_high_scores then
        Action = actions.waiting
        local f = io.open("fantasy_console/data/highscores.txt", "r")
        if not f then print("No fantasy_console/data/highscores.txt file!"); Write(60, 160 + ystep, "Your total score is: " .. score .. "."); return end
        local content = f:read "*a"
        f:close()
        local content_table_s = Split(content, "\n")
        local content_table = {}
        for _, value in ipairs(content_table_s) do
            table.insert(content_table, tonumber(value))
        end
        if #content_table < 10 then
            Highscore = true
            table.insert(content_table, score)
            table.sort(content_table)
            content = Join(content_table, "\n")
            local f = io.open("fantasy_console/data/highscores.txt", "w")
            if not f then print("No fantasy_console/data/highscores.txt file!"); Write(60, 160 + ystep, "Your total score is: " .. score .. "."); return end
            f:write(content)
        else
            for _, line in ipairs(content_table) do
                if score > tonumber(line) then
                    Highscore = true
                    table.insert(content_table, score)
                    table.sort(content_table)
                    table.remove(content_table, 1)
                    content = Join(content_table, "\n")
                    local f = io.open("fantasy_console/data/highscores.txt", "w")
                    if not f then print("No fantasy_console/data/highscores.txt file!"); Write(60, 160 + ystep, "Your total score is: " .. score .. "."); return end
                    f:write(content)
                    break
                end
            end
        end
    end
    if Highscore == false then
        Write(60, 160 + ystep, "Your total score is: " .. score .. ".")
    else
        Write(60, 160 + ystep, "HIGHSCORE!", RedBold)
        Write(60+43, 160 + ystep, "Your total score is: " .. score .. ".")
    end
    Write(192, 184, "ENTER to continue.", BlackBold)
end


function screen.draw_high_scores_menu()
    local ystep = 5
    Write(43, 10,              "                   ...    ...       ...........       ........       ...    ...              ", YellowBold)
    Write(43, 10+ystep,        "                  :::    :::           :::          :::    :::      :::    :::               ", Yellow)
    Write(43, 10+(ystep * 2),  "                 :::    :::           :::          :::             :::    :::                ", Yellow)
    Write(43, 10+(ystep * 3),  "                ::::::::::           :::          :::             ::::::::::                 ", Yellow)
    Write(43, 10+(ystep * 4),  "               :::    :::           :::          :::  :::::      :::    :::                  ", Yellow)
    Write(43, 10+(ystep * 5),  "              :::    :::           :::          :::    :::      :::    :::                   ", Yellow)
    Write(43, 10+(ystep * 6),  "              ;;;    ;;;       ;;;;;;;;;;;      ;;;;;;;;;;      ;;;    ;;;                    ", Red)
    Write(43, 12+(ystep * 7),  "      ........       ........       ........       .........       ..........       ........ ", YellowBold)
    Write(43, 12+(ystep * 8),  "    :::    :::     :::    :::     :::    :::      :::    :::      :::             :::    ::: ", Yellow)
    Write(43, 12+(ystep * 9),  "   :::            :::            :::    :::      :::    :::      :::             :::         ", Yellow)
    Write(43, 12+(ystep * 10), "  ::::::::::     :::            :::    :::      :::::::::       ::::::::        ::::::::::   ", Yellow)
    Write(43, 12+(ystep * 11), "        :::     :::            :::    :::      :::    :::      :::                    :::    ", Yellow)
    Write(43, 12+(ystep * 12), ":::    :::     :::    :::     :::    :::      :::    :::      :::             :::    :::     ", Yellow)
    Write(43, 12+(ystep * 13), ";;;;;;;;;;     ;;;;;;;;;;     ;;;;;;;;;;      ;;;    ;;;      ;;;;;;;;;;      ;;;;;;;;;;     ", Red)
    local f = io.open("fantasy_console/data/highscores.txt", "r")
    if not f then print("No fantasy_console/data/highscores.txt file!"); return end
    local content = f:read "*a"
    f:close()
    local content_table_s = Split(content, "\n")
    local i = #content_table_s
    local j = 1
    local ystep = 0
    local xstep = 0
    while i > 0 do
        Write(74+xstep, 94+ystep, j .. ". " .. content_table_s[i])
        ystep = ystep + 10
        j = j + 1
        if j == 6 then
            xstep = 62
            ystep = 0
        end
        i = i - 1
    end
    Write(192, 184, "ENTER to continue.", BlackBold)
end


function screen.draw_tutorial()
    if Tutorial == 1 then
        Rect(1, 1, (256/2) - 2, (192/2) - 15 - 2, YellowBold)
        Write(8, 10, "This is the map. The highlighted\nroom is where you are.", YellowBold)
        Write(8, 52, "On the right side, there are rooms\nyou can reach from current room.\nPress ENTER to continue.", YellowBold)
    elseif Tutorial == 2 then
        Rect(1, 1, (256/2) - 2, (192/2) - 15 - 2, Yellow)
        Write(8, 10, "This is the map. The highlighted\nroom is where you are.", Yellow)
        Write(8, 52, "On the right side, there are rooms\nyou can reach from current room.", Yellow)
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 12, YellowBold)
        Write(8, (192 / 2) - 15 + 60, "This is the main menu that you\nuse for interaction with\nthe game world.\nPress ENTER to select currently\nhighlighted option.", YellowBold)
    elseif Tutorial == 3 then
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 12, YellowBold)
        Write(8, (192 / 2) - 15 + 70, "Pay attention to the # marks\ninside the square brackets.\nThey indicate the current\ndanger level. Press ENTER.", YellowBold)
    elseif Tutorial == 4 then
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 12, Yellow)
        Write(8, (192 / 2) - 15 + 70, "Pay attention to the # marks\ninside the square brackets.\nThey indicate the current\ndanger level.", Yellow)
        Rect((256/2) + 2, (192 / 2) - 15 + 2, (256/2) - 4, (192/2) + 12, YellowBold)
        Write((256/2) + 8, (192 / 2) - 15 + 70, "Fighting uses Physique,\nfleeing uses Cunning,\ndiplomacy uses Empathy.\nPress ENTER.", YellowBold)
    elseif Tutorial == 5 then
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 12, Yellow)
        Write(8, (192 / 2) - 15 + 70, "Pay attention to the # marks\ninside the square brackets.\nThey indicate the current\ndanger level.", Yellow)
        Rect((256/2) + 2, (192 / 2) - 15 + 2, (256/2) - 4, (192/2) + 12, YellowBold)
        Write((256/2) + 8, (192 / 2) - 15 + 70, "Fighting uses Physique,\nfleeing uses Cunning,\ndiplomacy uses Empathy.\n", Yellow)
        Write((256/2) + 60, (192 / 2) - 15 + 30, "Please note that\nthe relevant skill\nis always\nhighlighted.\nPress ENTER.", YellowBold)
    elseif Tutorial == 6 then
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 12, Yellow)
        Write(8, (192 / 2) - 15 + 70, "Pay attention to the # marks\ninside the square brackets.\nThey indicate the current\ndanger level.", Yellow)
        Rect((256/2) + 2, (192 / 2) - 15 + 2, (256/2) - 4, (192/2) + 12, Yellow)
        Write((256/2) + 8, (192 / 2) - 15 + 70, "Fighting uses Physique,\nfleeing uses Cunning,\ndiplomacy uses Empathy.\n", Yellow)
        Write((256/2) + 60, (192 / 2) - 15 + 30, "Please note that\nthe relevant skill\nis always\nhighlighted.", Yellow)
        Rect((256/2) + 2, 1, (256/2) - 4, (192/2) - 15 - 2, YellowBold)
        Write((256/2) + 2 + 6, 22, "This is where dice roll.\nAmount of dice rolled is equal\nto the relevant skill level.\nNow, resolve the conflict.\nPress ENTER.", YellowBold)
    elseif Tutorial == 7 then
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 12, Yellow)
        Write(8, (192 / 2) - 15 + 70, "Pay attention to the # marks\ninside the square brackets.\nThey indicate the current\ndanger level.", Yellow)
        Rect((256/2) + 2, (192 / 2) - 15 + 2, (256/2) - 4, (192/2) + 12, Yellow)
        Write((256/2) + 8, (192 / 2) - 15 + 70, "Fighting uses Physique,\nfleeing uses Cunning,\ndiplomacy uses Empathy.\n", Yellow)
        Write((256/2) + 60, (192 / 2) - 15 + 30, "Please note that\nthe relevant skill\nis always\nhighlighted.", Yellow)
        Rect((256/2) + 2, 1, (256/2) - 4, (192/2) - 15 - 2, YellowBold)
        Write((256/2) + 2 + 6, 22, "This is where dice roll.\nAmount of dice rolled is equal\nto the relevant skill level.\nNow, resolve the conflict.", Yellow)
        if menu.option_chosen == 1 then
            Write((256/2) + 2 + 6, 56, "Fight: you need to win.\nIf you win, you get rewards.", YellowBold)
        elseif menu.option_chosen == 2 then
            Write((256/2) + 2 + 6, 56, "Flee: always successful,\nbut you might get hit.", YellowBold)
        elseif menu.option_chosen == 3 then
            Write((256/2) + 2 + 6, 56, "Diplomacy: one-time chance\nto resolve the conflict peacefully.\nFail makes the other tests harder.", YellowBold)
        end
    elseif Tutorial == 8 then
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 12, Yellow)
        Write(8, (192 / 2) - 15 + 70, "Pay attention to the # marks\ninside the square brackets.\nThey indicate the current\ndanger level.", Yellow)
        Rect((256/2) + 2, (192 / 2) - 15 + 2, (256/2) - 4, (192/2) + 12, Yellow)
        Write((256/2) + 8, (192 / 2) - 15 + 70, "Fighting uses Physique,\nfleeing uses Cunning,\ndiplomacy uses Empathy.\n", Yellow)
        Write((256/2) + 60, (192 / 2) - 15 + 30, "Please note that\nthe relevant skill\nis always\nhighlighted.", Yellow)
        Rect((256/2) + 2, 1, (256/2) - 4, (192/2) - 15 - 2, YellowBold)
        Write((256/2) + 2 + 6, 22, "This is where dice roll.\nAmount of dice rolled is equal\nto the relevant skill level.\nNow, resolve the conflict.", Yellow)
        Write((256/2) + 2 + 6, 56, "Now, proceed further.\nPress ENTER.", YellowBold)
    elseif Tutorial == 9 then
        Rect(1, 1, (256/2) - 2, (192/2) - 15 - 2, YellowBold)
        Write(8, 10, "You are in the merchant's room.", YellowBold)
        Write(8, 52, "You can either skip interaction,\npurchase or steal something.\nPress ENTER.", YellowBold)
    elseif Tutorial == 10 then
        Rect(1, 1, (256/2) - 2, (192/2) - 15 - 2, Yellow)
        Write(8, 10, "You are in the merchant's room.", Yellow)
        Write(8, 52, "You can either skip interaction,\npurchase or steal something.", Yellow)
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 6, YellowBold)
        Write(8, (192 / 2) - 15 + 70, "Let's try stealing. Navigate to\n\"Steal\" option.", YellowBold)
    elseif Tutorial == 11 then
        Rect(1, 1, (256/2) - 2, (192/2) - 15 - 2, Yellow)
        Write(8, 10, "You are in the merchant's room.", Yellow)
        Write(8, 52, "You can either skip interaction,\npurchase or steal something.", Yellow)
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 12, YellowBold)
        Write(8, (192 / 2) - 15 + 70, "Let's try stealing. Navigate to\n\"Steal\" option. If you fail test,\nmerchant won't interact with you\nanymore. Also the guild will raise\ntheir prices. Press ENTER.", YellowBold)
    elseif Tutorial == 12 then
        Rect(1, 1, (256/2) - 2, (192/2) - 15 - 2, Yellow)
        Write(8, 10, "You are in the merchant's room.", Yellow)
        Write(8, 52, "You can either skip interaction,\npurchase or steal something.", Yellow)
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 12, Yellow)
        Write(8, (192 / 2) - 15 + 70, "Let's try stealing. Navigate to\n\"Steal\" option. If you fail test,\nmerchant won't interact with you\nanymore. Also the guild will raise\ntheir prices.", Yellow)
        Rect((256/2) + 2, (192 / 2) - 15 + 2, (256/2) - 4, (192/2) + 12, YellowBold)
        Write((256/2) + 60, (192 / 2) - 15 + 30, "Dices above are\nin your inventory.\nTo pass the test,\nyou need at least", YellowBold)
        Write((256/2) + 7, (192 / 2) - 15 + 62, "as many successes (\"6\" at die) as\ncurrent danger level. To maximize\nchance of success, add dice to your\ndice pool. To do so, enter inventory\nby pressing right arrow.", YellowBold)
    elseif Tutorial == 13 or Tutorial == 14 or Tutorial == 15 or Tutorial == 16 or Tutorial == 17 then
        Rect(1, 1, (256/2) - 2, (192/2) - 15 - 2, Yellow)
        Write(8, 10, "You are in the merchant's room.", Yellow)
        Write(8, 52, "You can either skip interaction,\npurchase or steal something.", Yellow)
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 12, Yellow)
        Write(8, (192 / 2) - 15 + 70, "Let's try stealing. Navigate to\n\"Steal\" option. If you fail test,\nmerchant won't interact with you\nanymore. Also the guild will raise\ntheir prices.", Yellow)
        Rect((256/2) + 2, (192 / 2) - 15 + 2, (256/2) - 4, (192/2) + 12, YellowBold)
        Write((256/2) + 60, (192 / 2) - 15 + 30, "Dices above are\nin your inventory.\nTo pass the test,\nyou need at least", Yellow)
        Write((256/2) + 7, (192 / 2) - 15 + 62, "as many successes (\"6\" at die) as\ncurrent danger level. To maximize\nchance of success, add dice to your\ndice pool. To do so, enter inventory\nby pressing right arrow.", Yellow)
        Write((256/2) + 2 + 6, 22, "Now, mark both dice by pressing\nEnter when cursor is on them, and\nexit from inventory by pressing\nleft arrow. Then confirm roll\nby pressing Enter.", YellowBold)
    elseif Tutorial == 18 then
        Rect(1, 1, (256/2) - 2, (192/2) - 15 - 2, Yellow)
        Write(8, 10, "You are in the merchant's room.", Yellow)
        Write(8, 52, "You can either skip interaction,\npurchase or steal something.", Yellow)
        Rect(1, (192 / 2) - 15 + 2, (256/2) - 2, (192/2) + 12, YellowBold)
        Write(8, (192 / 2) - 15 + 70, "Let's try stealing. Navigate to\n\"Steal\" option. If you fail test,\nmerchant won't interact with you\nanymore. Also the guild will raise\ntheir prices.", Yellow)
        Rect((256/2) + 2, (192 / 2) - 15 + 2, (256/2) - 4, (192/2) + 12, Yellow)
        Write((256/2) + 60, (192 / 2) - 15 + 30, "Dices above are\nin your inventory.\nTo pass the test,\nyou need at least", Yellow)
        Write((256/2) + 7, (192 / 2) - 15 + 62, "as many successes (\"6\" at die) as\ncurrent danger level. To maximize\nchance of success, add dice to your\ndice pool. To do so, enter inventory\nby pressing right arrow.", Yellow)
        Write((256/2) + 2 + 6, 22, "Now, mark both dice by pressing\nEnter when cursor is on them, and\nexit from inventory by pressing\nleft arrow. Then confirm roll\nby pressing Enter.", Yellow)
        Write(8, (192 / 2) - 15 + 23, "Now you should steal something\nbut it's time to finish the tutorial...", Yellow)
    end
end


function screen.draw_dividers()
    Line(256/2, 0, 256/2, 192, BlackBold)
    Line(0, (192/2)-15, 256, (192/2)-15, BlackBold)
end


return screen
