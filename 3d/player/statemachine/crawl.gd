extends "res://3d/player/statemachine/state.gd"

const speed : float = 8

@onready var collision = $"../../CollisionShape3D"

func update(_delta):
	player_movement(speed)
	player_gravity()
	check_ceiling()
	
	if !Input.is_action_pressed("crawl") and !player.ceiling:
		return states.idle

func enter_state():
	player.play_animation("dash")
	collision.shape.size.y = 0.5

func exit_state():
	collision.shape.size.y = 1.3
