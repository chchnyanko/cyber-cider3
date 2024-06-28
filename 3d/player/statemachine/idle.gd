extends "res://3d/player/statemachine/state.gd"

#called each frame while the player's current state = idle
func update(_delta):
	#check the ceiling for when there is a low ceiling to change the camera automatically
	check_ceiling()
	
	#change state
	#if the player isn't on the floor anymore set state to fall
	if !player.is_on_floor():
		return states.fall
	#if the player does any directional input set state to walk
	if player.input_dir != Vector2.ZERO:
		return states.walk
	#if the player presses the jump button set state to jump
	if Input.is_action_just_pressed("jump"):
		return states.jump
	#if the player presser the crawl button set state to crawl
	if Input.is_action_pressed("crawl"):
		return states.crawl

#called when entering the state
func enter_state():
	#set player animation to idle
	player.play_animation("idle")
