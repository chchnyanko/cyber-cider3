extends "res://3d/player/statemachine/state.gd"

var jump_speed : float = 50 #vertical velocity when jumping
var speed : float = 12 #horizontal velocity when jumping

#called each frame while the player's current state = jump
func update(_delta):
	#apply gravity to the player
	player_gravity()
	player_movement(speed)
	
	#change states
	#if the player is moving down set state to fall
	if player.velocity.y <= 0:
		return states.fall
	#if the player is on a wall and can climb set state to climb idle
	if player.is_on_wall() and player.last_wall_pos == Vector3.ZERO:
		return states.climb_idle

#called when entering the state
func enter_state():
	#set the player's animation to jump
	player.play_animation("jump")
	#set the players y velocity to the jump speed
	player.velocity.y = jump_speed
