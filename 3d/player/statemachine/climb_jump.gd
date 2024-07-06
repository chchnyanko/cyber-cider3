extends "res://3d/player/statemachine/state.gd"

const jump_time : float = 0.1 #time from the start of the jump till the end
const speed : float = 50 #the velocity of the jumping motion

@onready var timer = $Timer #timer used to measure when to finish the jump

var jumping : bool = true #if the player is currently jumping

var leaving_wall : bool = false #if the player should leave the wall after jumping

#called each frame while the player's current state = climb jump
func update(_delta):
	#change state
	#if the player stops jumping (once the timer finishes) set state to climb
	if !jumping:
		if leaving_wall:
			return states.idle
		else:
			return states.climb

#called when the timer ends
func _on_timer_timeout():
	#stop jumping
	jumping = false

#called when entering the state
func enter_state():
	#set the player's animation to walljump
	player.play_animation("walljump")
	#set the camera's state to climb
	player.change_camera("climb")
	
	#start jumping
	jumping = true
	
	#set the players velocity
	#set x velocity to the input direction
	player.velocity = player.transform.basis.x * player.input_dir.x * speed
	#if the player is inputting any direction, set the y velocity to that of the input
	if player.input_dir != Vector2.ZERO:
		player.velocity.y = abs(player.input_dir.y) * speed
	#if not then set the y velocity to move up
	else:
		player.velocity.y = 1
	
	#if the player if holding down then make them leave the wall after jumping
	if player.input_dir.y > 0.5:
		leaving_wall = true
	else:
		leaving_wall = false
	#start the jump timer
	timer.start(jump_time)

#called when exiting the state
func exit_state():
	#set the camera state to back
	player.change_camera("back")
