extends Node

class_name state

const gravity : float = -2.5 #constant velocity used when player gravity function is called
const terminal_velocity : float = -40 #maximum gravity
const climb_speed : Vector2 = Vector2(10, 15) #velocity when climbing walls, (horizontal, vertical)

var states = null #reference to the $statemachine node used by states to set the state
var player : player = null #reference to the player node
var vely #store velocity.y so that it doesn't get broken by the transform.y kind of stuff
var ceiling_checker = null #reference to the shapecast used for 

#used by other states
func update(_delta):
	pass
#used by other states
func enter_state():
	pass
#used by other states
func exit_state():
	pass

#sets the players velocity with an input of speed
func player_movement(speed : int):
	#remember the player's current y velocity
	vely = player.velocity.y
	#set the players velocity to speed * the direction that the camera is facing
	player.velocity = player.camera.transform.basis.x * player.input_dir.x + player.camera.transform.basis.z * player.input_dir.y
	#multiply the player's velocity by speed
	player.velocity *= speed
	#reset the player's y velocity to the value that got remembered
	player.velocity.y = vely

#applies gravity to the player
func player_gravity():
	#decrease the player's vertical velocity if it is less than the maximum
	if player.velocity.y > terminal_velocity:
		player.velocity.y += gravity

#sets the player's velocity when the player is climbing walls
func player_climb():
	#get the angle that the wall is facing
	var normal = player.get_wall_normal()
	#move the player horizontally across the wall
	player.velocity = Vector3(normal.z, normal.y, -normal.x) * player.input_dir.x * climb_speed.x
	#move the player vertically if the player is inputting any 
	player.velocity.y = -player.input_dir.y * climb_speed.y

#checks if there is a low ceiling
func check_ceiling():
	#update the shapecast
	ceiling_checker.force_shapecast_update()
	#if there is a low ceiling set the camera state to side and the player's ceiling variable to true
	if ceiling_checker.is_colliding():
		player.change_camera("side")
		player.ceiling = true
	#if there isn't a low ceiling but the player's ceiling variable is true set it to false and set camera state to back
	elif player.ceiling:
		player.change_camera("back")
		player.ceiling = false
