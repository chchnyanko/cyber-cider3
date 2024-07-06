extends "res://3d/player/statemachine/state.gd"

#called each frame while the player's current state = climb idle
func update(_delta):
	#change the player's state
	#when the player presses a directional input set state to climb
	if player.input_dir != Vector2.ZERO:
		return states.climb
	#when the player presses the jump button set state to climb jump
	if Input.is_action_just_pressed("jump"):
		return states.climb_jump

#called when entering this state
func enter_state():
	#set the player's animation to wall
	player.play_animation("wall")
	#reset the player's velocity
	player.velocity = Vector3.ZERO
	#move the player up when they are coming from a non-climbing state
	#this fixes the issue of the player being on the floor and on the wall at the same time 
	#when first getting on the wall
	if !player.previous_state.name.contains("climb"):
		player.transform.origin.y += 1
	#if they were on the wall set the camera state to climb before the camera tries to go to back
	else:
		player.change_camera("climb")
	#wait 1 frame and set the camera state to climb
	#this is done because sometimes the player will enter the climb state without wanting to climb a wall
	#eg. when getting on a ledge
	#they will move up and over the ledge but I don't want the camera to freak out when this happens 
	#so I make it wait a frame
	await get_tree().process_frame
	if player.is_on_wall():
		player.change_camera("climb")

#called when exiting the state
#sets the camera state to back
func exit_state():
	player.change_camera("back")
