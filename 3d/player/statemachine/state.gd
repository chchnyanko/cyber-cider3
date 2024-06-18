extends Node

class_name state

const gravity : float = -10
const terminal_velocity : float = -40
const climb_speed : Vector2 = Vector2(10, 10)

var states = null
var player : player = null
var vely #store velocity.y so that it doesn't get broken by the transform.y kind of stuff
var ceiling_checker = null

func update(_delta):
	pass

func enter_state():
	pass

func exit_state():
	pass

func player_movement(speed):
	vely = player.velocity.y
	player.velocity = player.camera.transform.basis.x * player.input_dir.x + player.camera.transform.basis.z * player.input_dir.y
	player.velocity *= speed
	player.velocity.y = vely

func player_gravity():
	if player.velocity.y > terminal_velocity:
		player.velocity.y += gravity

func player_climb():
	var normal = player.get_wall_normal()
	player.velocity = Vector3(normal.z, normal.y, -normal.x) * player.input_dir.x * climb_speed.x
	player.velocity.y = -player.input_dir.y * climb_speed.y

func check_ceiling():
	ceiling_checker.force_shapecast_update()
	if ceiling_checker.is_colliding():
		player.change_camera("side")
		player.ceiling = true
	else:
		if player.ceiling:
			player.change_camera("back")
		player.ceiling = false
