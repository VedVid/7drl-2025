local menu = {}


function menu.new_menu(event, header, options)
    local new_menu = {}
    new_menu.event = event
    new_menu.header = header
    new_menu.options = options
    return new_menu
end


return menu
