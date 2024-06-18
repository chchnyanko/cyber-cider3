extends "res://3d/player/statemachine/state.gd"

var speed : float = 10

func update(_delta):
	player.play_animation("run")
	player_movement(speed)
	check_ceiling()
	if player.input_dir == Vector2.ZERO:
		return states.idle
	if !player.is_on_floor():
		return states.fall
	if player.is_on_wall() and player.last_wall_pos == Vector3.ZERO:
		return states.climb_idle
	if Input.is_action_just_pressed("jump"):
		return states.jump
	if Input.is_action_pressed("crawl"):
		return states.crawl
