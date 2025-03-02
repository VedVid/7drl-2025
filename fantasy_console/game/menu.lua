local menu = {}

menu.current_menu = nil
menu.option_chosen = 1

function menu.new_menu(event)
    local new_menu = {}
    new_menu.event = event
    new_menu.header = event.header
    new_menu.options = event.options
    return new_menu
end


return menu
