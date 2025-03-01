require "../api"

local screen = {}

function screen.draw_dividers()
    Line(256/2, 0, 256/2, 192, BlackBold)
    Line(0, (192/2)-15, 256, (192/2)-15, BlackBold)
end

return screen