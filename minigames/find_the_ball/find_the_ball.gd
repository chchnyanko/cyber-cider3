extends Node2D

@onready var ball = $cup2/ball

@export var moves : int

var current : bool = false

var cups : Array
var cup_pos : Array
var cup_target_pos : Array = [0, 1, 2]

var moving : bool = false
var cup_moving : bool = false
var finished_moving : bool = false
var selected_cup : int 

func _ready():
	for cup in get_children():
		if cup is TextureButton:
			cups.append(cup)
			cup_pos.append(cup.position)

func _process(delta):
	if Input.is_action_just_pressed("crawl"):
		current = true
	if current:
		if ball.position.y < 50:
			ball.position.y += 10
		elif !moving and !finished_moving:
			moving = true
		if moving:
			if !cup_moving:
				var ran = randi_range(0,2)
				moves -= 1
				if ran == 0:
					var pos = cup_target_pos[0]
					cup_target_pos[0] = cup_target_pos[1]
					cup_target_pos[1] = pos
					cup_moving = true
				if ran == 1:
					var pos = cup_target_pos[0]
					cup_target_pos[0] = cup_target_pos[2]
					cup_target_pos[2] = pos
					cup_moving = true
				if ran == 2:
					var pos = cup_target_pos[1]
					cup_target_pos[1] = cup_target_pos[2]
					cup_target_pos[2] = pos
					cup_moving = true
			if cup_moving:
				cups[0].position = lerp(cups[0].position, cup_pos[cup_target_pos[0]], 0.4)
				cups[1].position = lerp(cups[1].position, cup_pos[cup_target_pos[1]], 0.4)
				cups[2].position = lerp(cups[2].position, cup_pos[cup_target_pos[2]], 0.4)
				var num = 0
				for i in cups.size():
					if abs(cups[i].position - cup_pos[cup_target_pos[i]]) < Vector2(0.01, 0.01):
						num += 1
				if num == cups.size():
					cup_moving = false
					if moves == 0:
						moving = false
						finished_moving = true
						selected_cup = 0
		if finished_moving:
			cups[cup_target_pos.find(selected_cup)].grab_focus()
			if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_up"):
				selected_cup -= 1
				if selected_cup < 0:
					selected_cup = cups.size() - 1
			if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_down"):
				selected_cup += 1
				if selected_cup >= cups.size():
					selected_cup = 0
			if Input.is_action_just_pressed("ui_accept"):
				cups[cup_target_pos.find(selected_cup)].emit_signal("pressed")

func _on_cup_1_pressed():
	print("1 pressed")
	if finished_moving:
		lose()

func _on_cup_2_pressed():
	print("2 pressed")
	if finished_moving:
		win()

func _on_cup_3_pressed():
	print("3 pressed")
	if finished_moving:
		lose()

func win():
	print("You win")

func lose():
	print("You lose")
