extends "res://3d/player/statemachine/state.gd"

var speed : float = 17 #the horizontal velocity when walking

#called each frame while the player's current state = walk
func update(_delta):
	#move the player with velocity of speed
	player_movement(speed)
	#check the ceiling for when there is a low ceiling to change the camera automatically
	check_ceiling()
	
	#change state
	#if the player isn't inputting any directional inputs set state to idle
	if player.input_dir == Vector2.ZERO:
		return states.idle
	#if the player isn't on the floor set state to fall
	if !player.is_on_floor():
		return states.fall
	#if the player is on a wall and is able to climb set state to climb idle
	if player.is_on_wall() and player.last_wall_pos == Vector3.ZERO:
		return states.climb_idle
	#if the player pressed the jump button set state to jump
	if Input.is_action_just_pressed("jump"):
		return states.jump
	#if the player pressed the crawl button set state to crawl
	if Input.is_action_pressed("crawl"):
		return states.crawl

#called when entering the state
func enter_state():
	#set the player's animation to run
	player.play_animation("run")
