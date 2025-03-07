local player = require "game/player"


local events_options = {}

events_options.go_to_first_room = "Go to first room"
events_options.go_to_second_room = "Go to second room"
events_options.go_to_third_room = "Go to third room"
events_options.purchase = "Purchase"
events_options.steal_from = "Steal from"
events_options.leave = "Leave"
events_options.fight = "Fight"
events_options.try_to_flee = "Try to flee"
events_options.try_diplomacy = "Try diplomacy"
events_options.proceed = "Proceed"
events_options.go_back = "Go back"
events_options.search_pockets = "Search the pockets"
events_options.help_smaller_group = "Help the smaller group"
events_options.help_larger_group = "Help the larger group"
events_options.try_to_mediate = "Try to mediate"

events_options.lookup_with_dice = {
    [events_options.steal_from] = player.skills[2],
    [events_options.fight] = player.skills[1],
    [events_options.try_to_flee] = player.skills[2],
    [events_options.try_diplomacy] = player.skills[3],
    [events_options.search_pockets] = player.skills[2],
    [events_options.help_smaller_group] = player.skills[1],
    [events_options.help_larger_group] = player.skills[1],
    [events_options.try_to_mediate] = player.skills[3]
}

return events_options
