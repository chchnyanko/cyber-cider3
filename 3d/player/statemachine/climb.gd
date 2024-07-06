extends "res://3d/player/statemachine/state.gd"

#called each frame while the player's current state = climb
func update(_delta):
	#let the player move around on the walls
	player_climb()
	
	#change the player's state
	#if there isn't any input set state to climb idle
	if player.input_dir == Vector2.ZERO:
		return states.climb_idle
	#if the player presses jump then set state to climb jump
	if Input.is_action_just_pressed("jump"):
		return states.climb_jump
	#if the player touches the floor or falls aff the wall then set state to idle 
	#and set the last wall pos to current position
	if player.is_on_floor() or !player.is_on_wall():
		player.last_wall_pos = player.global_transform.origin
		return states.idle

#called when entering this state
#set the player's animation to wall and the camera state to climb
func enter_state():
	player.play_animation("wall")
	player.change_camera("climb")

#called when exiting the state
#set the camera state to back
func exit_state():
	player.change_camera("back")

