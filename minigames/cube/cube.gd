extends Node3D

@export var set_faces : Array[PackedScene]

var face_angles : Array[Vector3]

var current_face : int = 0

var faces : Array[Node2D]

func _ready():
	var num = 0
	for face in get_children():
		if face is MeshInstance3D:
			face_angles.append(-face.rotation)
		if face is SubViewport:
			var scene = set_faces[num].instantiate()
			face.add_child(scene)
			faces.append(scene)
			num += 1

func _process(delta):
	if Input.is_key_pressed(KEY_1):
		change_game(0)
	if Input.is_key_pressed(KEY_2):
		change_game(1)
	if Input.is_key_pressed(KEY_3):
		change_game(2)
	if Input.is_key_pressed(KEY_4):
		change_game(3)
	if Input.is_key_pressed(KEY_5):
		change_game(4)
	if Input.is_key_pressed(KEY_6):
		change_game(5)
	rotation.x = lerp_angle(rotation.x, face_angles[current_face].x, 0.1)
	rotation.y = lerp_angle(rotation.y, face_angles[current_face].y, 0.1)
	rotation.z = lerp_angle(rotation.z, face_angles[current_face].z, 0.1)

func change_game(next_game : int):
	faces[current_face].current = false
	faces[next_game].current = true
	current_face = next_game
	#print(next_game + 1)
