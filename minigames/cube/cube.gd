extends Node3D

var face_angles : Array[Vector3]

var current_face : int = 0

func _ready():
	for face in get_children():
		if face is Sprite3D:
			face_angles.append(-face.rotation)

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		current_face = randi_range(0,5)
		print(current_face + 1)
	if Input.is_key_pressed(KEY_1):
		current_face = 0
		print("1")
	if Input.is_key_pressed(KEY_2):
		current_face = 1
		print("2")
	if Input.is_key_pressed(KEY_3):
		current_face = 2
		print("3")
	if Input.is_key_pressed(KEY_4):
		current_face = 3
		print("4")
	if Input.is_key_pressed(KEY_5):
		current_face = 4
		print("5")
	if Input.is_key_pressed(KEY_6):
		current_face = 5
		print("6")
	rotation.x = lerp_angle(rotation.x, face_angles[current_face].x, 0.1)
	rotation.y = lerp_angle(rotation.y, face_angles[current_face].y, 0.1)
	rotation.z = lerp_angle(rotation.z, face_angles[current_face].z, 0.1)
	#if abs(rotation - face_angles[current_face]) < Vector3(0.01, 0.01, 0.01):
		#current_face = randi_range(0,5)
		#print(current_face + 1)
