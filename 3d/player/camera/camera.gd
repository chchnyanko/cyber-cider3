extends Node3D

const position_presets : Dictionary = {
	"back" : [Vector3(0, 3, 7), Vector3(-0.35, 0, 0)],
	"side" : [Vector3(10, 0, 0), Vector3(0, PI, 0)]
}

@export var target : Node

@onready var camera = $Camera3D

var target_pos : Vector3 #position of the target
var target_angle : Vector3 #angle tha the camera should be pointing
var lock_pos : Vector3 #position of where to lock at
var lock_angle : Vector3 #angle when locked
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
		pos = target_pos + position_presets.get(camera_state)[0]
		target_angle = position_presets.get(camera_state)[1]
	elif camera_state == "climb":
		if target.get_wall_normal():
			pos = target_pos + target.get_wall_normal() * 10
			target_angle = Vector3(0, atan2(target.get_wall_normal().x, target.get_wall_normal().z) * 2, 0)
	if result:
		camera_pos = result.position
	else:
		camera_pos = pos
	
	if camera_state == "lock":
		target_angle = lock_angle
		camera.global_transform.origin = lerp(camera.global_transform.origin, lock_pos, 0.2)
	else:
		global_transform.origin = lerp(global_transform.origin, pos, 0.2)
		camera.global_transform.origin = lerp(camera.global_transform.origin, camera_pos, 0.2)
	
	transform.basis = Basis.from_euler(lerp(transform.basis.get_euler(), target_angle - transform.basis.get_euler(), 0.2))

func change_state(new_state):
	if camera_state != "lock":
		if new_state == "change":
			if camera_state == "back":
				camera_state = "side"
			elif camera_state == "side":
				camera_state = "back"
		else:
			camera_state = new_state
	else:
		if new_state == "unlock":
			camera_state = "back"
	if new_state == "lock":
		rotation = Vector3(0, 0, 0)
