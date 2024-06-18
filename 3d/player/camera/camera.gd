extends Node3D

const position_presets : Dictionary = {
	"back" : Vector3(0, 3, 7),
	"side" : Vector3(10, 0, 0)
}

@export var target : Node

@onready var camera = $Camera3D

var target_pos : Vector3 #position of the target
var pos : Vector3 #the position behind the player
var camera_pos : Vector3 #the position that the camera tries to move towards
var camera_state : String = "back" 

func _physics_process(_delta):
	var space = get_world_3d().direct_space_state
	target_pos = target.global_transform.origin
	var query = PhysicsRayQueryParameters3D.create(target_pos, global_transform.origin)
	query.exclude = [target]
	query.hit_from_inside = true
	var result = space.intersect_ray(query)
	if position_presets.get(camera_state):
		pos = target_pos + position_presets.get(camera_state)
	elif camera_state == "climb":
		if target.get_wall_normal():
			pos = target_pos + target.get_wall_normal() * 10
	if result:
		camera_pos = result.position
	else:
		camera_pos = pos
	
	global_transform.origin = lerp(global_transform.origin, pos, 0.2)
	camera.global_transform.origin = lerp(camera.global_transform.origin, camera_pos, 0.2)
	look_at(target_pos)

func change_state(new_state):
	if new_state == "change":
		if camera_state == "back":
			camera_state = "side"
		elif camera_state == "side":
			camera_state = "back"
	else:
		camera_state = new_state
