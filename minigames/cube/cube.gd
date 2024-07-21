extends Node3D

@export var set_faces : Array[PackedScene] ## The six minigames that are played on this cube

@onready var animation = $"../AnimationPlayer" #reference to the animation player in charge of moving the camera

@onready var input_forwarder = $"../input_forwarder" #reference to the input forwwarder

var face_angles : Array[Vector3] #the rotation needed for the cube to be facing that game

var current_face : int = 0 #the current face of the cube that is being shown and played

var faces : Array[Node2D] #references to the main nodes of the minigame scenes

var rotating : bool = false #if the cube is currently changing faces

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
	if rotating:
		#rotate the cube to show the current minigame
		rotation.x = lerp_angle(rotation.x, face_angles[current_face].x, 0.1)
		rotation.y = lerp_angle(rotation.y, face_angles[current_face].y, 0.1)
		rotation.z = lerp_angle(rotation.z, face_angles[current_face].z, 0.1)
		
		if global_rotation.distance_squared_to(face_angles[current_face]) < 0.01 or global_rotation.distance_squared_to(face_angles[current_face]) > 35:
			#make the current game current
			animation.play("start_game")
	
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
	if Input.is_key_pressed(KEY_F1):
		change_game(randi_range(0,5))

#called when changing the current minigame
func change_game(next_game : int):
	#make the last game not current
	faces[current_face].current = false
	#set the current face to the current minigame
	current_face = next_game
	animation.play("end_game")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "end_game":
		#start rotating the cube
		rotating = true
	if anim_name == "start_game":
		faces[current_face].current = true
		input_forwarder.change_game(get_node(str("side",current_face+1)),get_node(str("game",current_face+1)))
		rotation = face_angles[current_face]
		#stop rotating the cube
		rotating = false
