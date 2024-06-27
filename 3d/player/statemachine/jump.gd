extends "res://3d/player/statemachine/state.gd"

var jump_speed : float = 50

func enter_state():
	player.play_animation("jump")
	player.velocity.y = jump_speed

func update(_delta):
	player_gravity()
	if player.get_position_delta().y <= 0:
		return states.fall
	if player.is_on_wall() and player.last_wall_pos == Vector3.ZERO:
		return states.climb_idle
