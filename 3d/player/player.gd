extends CharacterBody3D

class_name player

@export var camera : Node3D ## The camera that will be following the player

@onready var statemachine = $statemachine #the parent node of all of the states
@onready var sprite = $AnimatedSprite3D #the animated sprite node in charge of the visuals of the player
@onready var ceiling_checker = $ceiling_checker #the shapecast used to check if there is a low ceiling
@onready var shadow_ray = $shadow_ray #the raycast used to project the shadow of the player
@onready var shadow = $shadow #the decal used to show the player's shadow

var current_state : state = null #the state that is currently active
var previous_state : state = null #the last state that was active

var input_dir : Vector2 #a vector of the directional input

var ceiling : bool #tells if there is a low ceiling above the player or not

var last_wall_pos : Vector3 #the last position where the player was on a wall

#called when the player first gets instanced by the scene
func _ready() -> void:
	#set the states, player and ceiling checker variables for the states
	for states in statemachine.get_children():
		states.states = statemachine
		states.player = self
		states.ceiling_checker = ceiling_checker
	#set the players initial state
	current_state = statemachine.idle

#called every physics frame
func _physics_process(delta: float) -> void:
	#used for kinematic body interactions with the world
	move_and_slide()
	#update the input direction
	input_dir = Input.get_vector("left", "right", "up", "down")
	#upate the current state which will return a state to change to or null
	change_state(current_state.update(delta))
	#flip the sprite to face the direction the player is moving
	if input_dir.x < 0:
		sprite.flip_h = true
	elif input_dir.x > 0:
		sprite.flip_h = false
	#reset the last wall position if the player has gotten far enough from the wall
	if last_wall_pos != Vector3.ZERO:
		if abs(last_wall_pos - global_transform.origin).length_squared() > 4:
			last_wall_pos = Vector3.ZERO
	#set the shadow's position
	shadow_ray.force_raycast_update()
	var ray_pos = shadow_ray.get_collision_point()
	shadow.global_position = ray_pos
	
	#change the camera state if the player presses the change camera button
	if Input.is_action_just_pressed("change_camera"):
		change_camera("change")
	
	#debug
	if $CanvasLayer/VBoxContainer.size > $CanvasLayer/VBoxContainer.custom_minimum_size:
		$CanvasLayer/VBoxContainer.custom_minimum_size = $CanvasLayer/VBoxContainer.size
	$CanvasLayer/VBoxContainer/velocity.text = str("Current Velocity: ", get_position_delta())
	$CanvasLayer/VBoxContainer/state.text = str("Current State: ", current_state.name)
	$CanvasLayer/VBoxContainer/animation.text = str("Current Animation: ", sprite.animation)
	$CanvasLayer/VBoxContainer/camera_state.text = str("Current Camera State: ", camera.camera_state)
	$CanvasLayer/VBoxContainer/camera_position.text = str("Camera Position: ", camera.camera_pos)
	if $ceiling_checker.is_colliding():
		$CanvasLayer/VBoxContainer/ceiling_checker_collision.text = str("Ceiling Checker Collisions: ", $ceiling_checker.get_collider(0))
	else:
		$CanvasLayer/VBoxContainer/ceiling_checker_collision.text = str("Ceiling Checker Collisions: None")
	$CanvasLayer/VBoxContainer/wall_normal.text = str("Wall Normal: ", get_wall_normal())
	$CanvasLayer/VBoxContainer/last_climb_pos.text = str("Last Climb Position: ", last_wall_pos)

#called every frame when updating the state, can also change the current state
func change_state(next_state: state) -> void:
	#if the player state is changing
	if next_state != null:
		if next_state.name.contains("climb"):
			if !unlocks.climb:
				return
		if next_state.name == "crawl":
			if !unlocks.crawl:
				return
		#set previous state to the state that we just exit and call exit state on that state
		previous_state = current_state
		previous_state.exit_state()
		#set current state to the new state and call enter state on that state
		current_state = next_state
		current_state.enter_state()

#called when changing the player's animation
func play_animation(animation: String) -> void:
	sprite.play(animation)

#called when changing the camera's state
func change_camera(camera_pos: String) -> void:
	camera.change_state(camera_pos)

#called when the player dies - either falls from a height or something else
func death() -> void:
	await is_on_floor() == true
	get_tree().reload_current_scene()

#debug
func _on_check_button_pressed() -> void:
	$CanvasLayer/VBoxContainer.visible = !$CanvasLayer/VBoxContainer.visible
	$CanvasLayer/CheckButton.release_focus()

func _on_button_pressed() -> void:
	unlocks.climb = true
	unlocks.crawl = true
	for i in unlocks.cube_1:
		i = true
	for i in unlocks.cube_2:
		i = true
	for i in unlocks.cube_3:
		i = true
	$CanvasLayer/VBoxContainer/Button.queue_free()
