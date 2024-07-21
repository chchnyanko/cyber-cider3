extends Node3D

#preset [position, angle] for each of the camera states
const position_presets : Dictionary = {
	"back" : [Vector3(0, 5, 4), Vector3(-PI/2, 0, 0)],
	"side" : [Vector3(10, 0, 0), Vector3(0, PI, 0)]
}


@export var target : Node ## The node that this camera will be targeting / following (usually the player)

@onready var camera = $Camera3D #the camera node

var target_pos : Vector3 #position of the target
var target_angle : Vector3 #angle tha the camera should be pointing
var lock_pos : Vector3 #position of where to lock at
var lock_angle : Vector3 #angle when locked
var pos : Vector3 #the position behind the player
var camera_pos : Vector3 #the position that the camera tries to move towards
var camera_state : String = "back" #The current camera state - default = back

func _physics_process(_delta):
	#settings up a ray between the target node and this node
	target_pos = target.global_transform.origin
	var space = get_world_3d().direct_space_state
	#create a query for making the ray
	var query = PhysicsRayQueryParameters3D.create(target_pos, global_transform.origin)
	#don't include the target because that will make it always collide with the target
	query.exclude = [target]
	#hit from inside is needed because sometimes the walls that the ray hits are the wrong way
	query.hit_from_inside = true
	#get the collision
	var result = space.intersect_ray(query)
	
	#set the position based on the current state
	#if there is a preset position then set the position to that
	if position_presets.get(camera_state):
		pos = target_pos + position_presets.get(camera_state)[0]
		target_angle = position_presets.get(camera_state)[1]
	#if not then if climb use the wall normal to find the correct position
	elif camera_state == "climb":
		if target.get_wall_normal():
			pos = target_pos + target.get_wall_normal() * 10
			target_angle = Vector3(0, atan2(target.get_wall_normal().x, target.get_wall_normal().z) * 2, 0)
		else:
			pos = target_pos
	#if the ray from above is colliding, move the cameras position to the collisions position
	if result:
		camera_pos = result.position
	else:
		camera_pos = pos
	
	#move the camera
	#if the state is lock then set the position to the lock position
	if camera_state == "lock":
		target_angle = lock_angle
		camera.global_transform.origin = lerp(camera.global_transform.origin, lock_pos, 0.2)
	#if not then move towards the correct position
	else:
		global_transform.origin = lerp(global_transform.origin, pos, 0.2)
		camera.global_transform.origin = lerp(camera.global_transform.origin, camera_pos, 0.2)
	#rotate the camera to face the correct angle
	transform.basis = Basis.from_euler(lerp(transform.basis.get_euler(), target_angle - transform.basis.get_euler(), 0.2))

#changing camera states
func change_state(new_state): #called from other scripts
	#if the camera isn't currenly locked
	if camera_state != "lock":
		#if the player clicked the change camera button then change the camera
		if new_state == "change":
			if camera_state == "back":
				camera_state = "side"
			elif camera_state == "side":
				camera_state = "back"
		#if the next state is manually set, then set it here
		else:
			camera_state = new_state
	#if the camera is locked then allow it to be unlocked
	else:
		if new_state == "unlock":
			camera_state = "back"
	#when locking the camera, reset the rotation so that the camera isn't slightly on an angle
	if new_state == "lock":
		rotation = Vector3(0, 0, 0)
