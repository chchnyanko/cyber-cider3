extends "res://3d/player/statemachine/state.gd"

func update(_delta):
	player_climb()
	if player.input_dir == Vector2.ZERO:
		return states.climb_idle
	if !player.is_on_wall():
		player.last_wall_pos = player.global_transform.origin
		return states.idle
	if Input.is_action_just_pressed("jump"):
		player.last_wall_pos = player.global_transform.origin
		return states.climb_jump
	if player.is_on_floor():
		player.last_wall_pos = player.global_transform.origin
		return states.idle

func enter_state():
	player.play_animation("wall")
	player.change_camera("climb")

func exit_state():
	player.change_camera("back")
