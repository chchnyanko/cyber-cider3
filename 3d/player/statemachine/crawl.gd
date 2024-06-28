extends "res://3d/player/statemachine/state.gd"

const speed : float = 8 #the horizontal velocity when crawling

@onready var collision = $"../../CollisionShape3D" #the player's collision box, used to shrink the size

#called each frame while the player's current state = crawl
func update(_delta):
	#move the player with velocity of speed
	player_movement(speed)
	#apply gravity to the player
	player_gravity()
	#check the ceiling for when there is a low ceiling to change the camera automatically
	check_ceiling()
	
	#change state
	#when the crawl button is released and there is nothing above the player that could cause issues
	#set state to idle
	if !Input.is_action_pressed("crawl") and !player.ceiling:
		return states.idle

#called when entering the state
func enter_state():
	#set the player's animation to dash
	player.play_animation("dash")
	#make the collision box's size smaller
	collision.shape.size.y = 0.5

#called when exiting the state
func exit_state():
	#reset the size of the collision box
	collision.shape.size.y = 1.3
	#move the player up a little bit so that they aren't inside of the ground when the collision box expands
	player.transform.origin.y += 0.3
