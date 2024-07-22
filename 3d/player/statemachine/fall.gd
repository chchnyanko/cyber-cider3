extends "res://3d/player/statemachine/state.gd"

const speed : float = 13 #the horizontal velocity while falling
const coyote_time : float = 0.2 #the time where the player can jump in mid-air in seconds
const crumple_time : float = 1 #the time it takes for the player to crumple and die when falling

@onready var coyote_timer = $coyote_timer #reference to the timer node for coyote time

var can_jump : bool = false #if the player can jump mid-air or not

var crumple_timer : float = 0 #the time that the player has been falling

#called each frame while the player's current state = fall
func update(delta):
	#move the player with velocity of speed
	player_movement(speed)
	#apply gravity to the player
	player_gravity()
	#increase the crumple timer
	crumple_timer += delta
	print(crumple_timer)
	#kill the player if crumple timer is greater than crumple time
	if crumple_timer > crumple_time and player.is_on_floor() and !unlocks.climb:
		player.death()
	#change state
	if can_jump and Input.is_action_just_pressed("jump"):
		return states.jump
	#if the player lands on the floor set state to idle
	if player.is_on_floor():
		return states.idle
	#if the player is on a wall and is able to climb then set state to climb idle
	if player.is_on_wall() and player.last_wall_pos == Vector3.ZERO:
		return states.climb_idle

#called when entering the state
func enter_state():
	#reset the crumple timer
	crumple_timer = 0
	#set player animation to fall
	player.play_animation("fall")
	#if the player just started falling  off a platform set the timer for coyote time and let them jump mid-air
	if player.previous_state != states.jump and player.previous_state != states.climb_jump:
		coyote_timer.start(coyote_time)
		can_jump = true

#called when the coyote timer finishes
func _on_coyote_timer_timeout():
	#make the player not be able to jump mid-air
	can_jump = false
