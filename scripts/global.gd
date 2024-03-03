extends Node

var player_current_attack = false

var current_scene = "world" # "world" | "cliff_side"
var transition_scene = false

var player_exit_cliff_side_position_x = 200
var player_exit_cliff_side_position_y = 22
var player_start_position_x = 117
var player_start_position_y = 131

var game_first_loading = true

func finish_change_scene():
	if transition_scene == true:
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"
		transition_scene = false
		global.game_first_loading = false
