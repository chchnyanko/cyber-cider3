extends Node3D

@export var set_faces : Array[PackedScene] #the six minigames that are played on this cube

var face_angles : Array[Vector3] #the rotation needed for the cube to be facing that game

var current_face : int = 0 #the current face of the cube that is being shown and played

var faces : Array[Node2D] #references to the main nodes of the minigame scenes

#called when this scene is first instanced
func _ready():
	#set a variable to keep count on the number of games being instanced
	var num = 0
	#for each of the child nodes
	for face in get_children():
		#if it's a face, add it's rotation to the face angles array
		if face is MeshInstance3D:
			face_angles.append(-face.rotation)
		#if it's a sub viewport, instance and add the corresponding minigame scene 
		#and add it to the faces array
		if face is SubViewport:
			var scene = set_faces[num].instantiate()
			face.add_child(scene)
			faces.append(scene)
			num += 1

#called every process frame
func _process(delta):
	#rotate the cube to show the current minigame
	rotation.x = lerp_angle(rotation.x, face_angles[current_face].x, 0.1)
	rotation.y = lerp_angle(rotation.y, face_angles[current_face].y, 0.1)
	rotation.z = lerp_angle(rotation.z, face_angles[current_face].z, 0.1)
	
	#debug
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

#called when changing the current minigame
func change_game(next_game : int):
	#make the last game not current
	faces[current_face].current = false
	#make the current game current
	faces[next_game].current = true
	#set the current face to the current minigame
	current_face = next_game
