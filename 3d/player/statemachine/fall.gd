extends "res://3d/player/statemachine/state.gd"

const speed : float = 8 #the horizontal velocity while falling

#called each frame while the player's current state = fall
func update(_delta):
	#move the player with velocity of speed
	player_movement(speed)
	#apply gravity to the player
	player_gravity()
	
	#change state
	#if the player lands on the floor set state to idle
	if player.is_on_floor():
		return states.idle
	#if the player is on a wall and is able to climb then set state to climb idle
	if player.is_on_wall() and player.last_wall_pos == Vector3.ZERO:
		return states.climb_idle

#called when entering the state
func enter_state():
	#set player animation to fall
	player.play_animation("fall")
