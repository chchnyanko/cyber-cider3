extends "res://3d/player/statemachine/state.gd"

func update(_delta):
	player.play_animation("idle")
	check_ceiling()
	if !player.is_on_floor():
		return states.fall
	if player.input_dir != Vector2.ZERO:
		return states.walk
	if Input.is_action_just_pressed("jump"):
		return states.jump
	if Input.is_action_pressed("crawl"):
		return states.crawl
