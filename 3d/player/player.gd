extends CharacterBody3D

class_name player

@export var camera : Node3D

@onready var statemachine = $statemachine
@onready var sprite = $AnimatedSprite3D
@onready var ceiling_checker = $ceiling_checker
@onready var shadow_ray = $shadow_ray
@onready var shadow = $shadow

var current_state : state = null
var previous_state : state = null

var input_dir : Vector2

var ceiling : bool

var last_wall_pos : Vector3

func _ready():
	for states in statemachine.get_children():
		states.states = statemachine
		states.player = self
		states.ceiling_checker = ceiling_checker
	current_state = statemachine.idle

func _physics_process(delta):
	move_and_slide()
	
	change_state(current_state.update(delta))
	
	input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir.x < 0:
		sprite.flip_h = true
	elif input_dir.x > 0:
		sprite.flip_h = false
	
	if Input.is_action_just_pressed("change_camera"):
		change_camera("change")
	
	if last_wall_pos != Vector3.ZERO:
		if abs(last_wall_pos - global_transform.origin).length_squared() > 4:
			last_wall_pos = Vector3.ZERO
	
	shadow_ray.force_raycast_update()
	var ray_pos = shadow_ray.get_collision_point()
	shadow.global_position = ray_pos
	
	#debug
	
	
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

func change_state(next_state):
	if next_state != null:
		previous_state = current_state
		previous_state.exit_state()
		current_state = next_state
		current_state.enter_state()

func play_animation(animation):
	sprite.play(animation)

func change_camera(camera_pos):
	camera.change_state(camera_pos)

#debug
func _on_check_button_pressed():
	$CanvasLayer/VBoxContainer.visible = !$CanvasLayer/VBoxContainer.visible
