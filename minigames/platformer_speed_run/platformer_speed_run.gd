extends Node2D

var current : bool = false #set to true if this is the minigame that is currently being played

@onready var tile_map = $TileMap

@onready var character = $character

const speed : float = 200

const gravity : float = 20

const jump_speed : float = 500

func win():
	print("got to the top")

func _ready():
	var last_x = 15
	var last_y = 31
	while last_y >= 3:
		randomize()
		var plsmns = [-1, 1]
		var dir = plsmns[randi() % 2]
		var pos = Vector2(clamp(1, 32, randi_range(last_x + 1 * dir, last_x + 5 * dir)), clamp(3, 31, randi_range(last_y - 5, last_y - 3)))
		last_x = pos.x
		last_y = pos.y
		for i in randi_range(1, 10):
			tile_map.set_cell(0, pos + Vector2(i * dir, 0), 4, Vector2i(7, 3))

func _physics_process(delta):
	if current:
		character.move_and_slide()
		character.velocity.y += gravity
		character.velocity.x = Input.get_axis("left", "right") * speed
		if character.is_on_floor():
			if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("up"):
				character.velocity.y = - jump_speed
		if character.position.y < 20:
			win()
