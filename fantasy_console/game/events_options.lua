local player = require "game/player"


local events_options = {}

events_options.go_to_first_room = "Go to first room"
events_options.go_to_second_room = "Go to second room"
events_options.go_to_third_room = "Go to third room"
events_options.purchase = "Purchase"
events_options.sell = "Sell"
events_options.pickpocket = {"Pickpocket", player.skills[2]}
events_options.leave = "Leave"
events_options.fight = {"Fight", player.skills[1]}
events_options.try_to_flee = {"Try to flee", player.skills[2]}
events_options.try_diplomacy = {"Try diplomacy", player.skills[3]}
events_options.proceed = "Proceed"

return events_options
