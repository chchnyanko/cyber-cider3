extends "res://3d/player/statemachine/state.gd"

const jump_time : float = 0.1
const speed : float = 50

@onready var timer = $Timer

var jumping : bool = true

func update(_delta):
	if !jumping:
		return states.climb

func _on_timer_timeout():
	jumping = false

func enter_state():
	player.play_animation("walljump")
	player.change_camera("climb")
	jumping = true
	player.velocity = player.transform.basis.x * player.input_dir.x * speed
	player.velocity.y = -player.input_dir.y * speed
	timer.start(jump_time)

func exit_state():
	player.change_camera("back")
