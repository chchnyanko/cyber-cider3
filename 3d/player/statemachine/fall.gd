extends "res://3d/player/statemachine/state.gd"

const speed : float = 8

func enter_state():
	player.play_animation("fall")

func update(_delta):
	player_movement(speed)
	player_gravity()
	if player.is_on_floor():
		return states.idle
	if player.is_on_wall() and player.last_wall_pos == Vector3.ZERO:
		return states.climb_idle
