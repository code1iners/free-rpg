extends Node2D

func _ready():
	if global.game_first_loading == true:
		$player.position.x = global.player_start_position_x
		$player.position.y = global.player_start_position_y
	else:
		$player.position.x = global.player_exit_cliff_side_position_x
		$player.position.y = global.player_exit_cliff_side_position_y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scenes()


func _on_cliff_side_transition_point_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func _on_cliff_side_transition_point_body_exited(body):
	if body.has_method("player"):
		#global.transition_scene = false
		pass

func change_scenes():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			global.finish_change_scene()
