extends "res://3d/player/statemachine/state.gd"

func update(_delta):
	if player.input_dir != Vector2.ZERO:
		return states.climb
	if Input.is_action_just_pressed("jump"):
		return states.climb_jump

func enter_state():
	player.play_animation("wall")
	player.velocity = Vector3.ZERO
	if !player.previous_state.name.contains("climb"):
		player.transform.origin.y += 1
	else:
		player.change_camera("climb")
	await get_tree().process_frame
	if player.is_on_wall():
		player.change_camera("climb")

func exit_state():
	player.change_camera("back")
