extends Node2D

@export_range(3,100) var moves : int #the maximum number of moves that the ball will make before stopping

@onready var ball = $cup2/ball #reference to the ball node

var current : bool = false #set to true if this is the minigame that is currently being played

var cups : Array #stores references to each cup
var cup_pos : Array #stores the target position of each cup
var cup_target_pos : Array = [0, 1, 2] #stores the number position of where the cup should go to

var moving : bool = false #if the moves variable is above 0 this will be true else false
var cup_moving : bool = false #if the cups are currenly moving
var finished_moving : bool = false #if all of the cups have finished moving
var selected_cup : int #the cup that is currently selected by the player

#called when this scene is first instanced
func _ready():
	#for each of this node's children
	for cup in get_children():
		#if it is a button add the node to cups and the position to cup pos
		if cup is TextureButton:
			cups.append(cup)
			cup_pos.append(cup.position)

#called every process frame
func _process(delta):
	#if this is the currently played minigame
	if current:
		#move the ball into the cup
		if ball.position.y < 50:
			ball.position.y += 10
		#once the ball is in the cup start moving
		elif !moving and !finished_moving:
			moving = true
		#when moving
		if moving:
			#if the cups aren't moving
			if !cup_moving:
				#choose a random move
				var ran = randi_range(0,2)
				#subtract 1 from moves left
				moves -= 1
				#set the target pos for each random outcome and make the cup start moving
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
			#if the cup is moving
			if cup_moving:
				#move the cups toward their target positions
				cups[0].position = lerp(cups[0].position, cup_pos[cup_target_pos[0]], 0.4)
				cups[1].position = lerp(cups[1].position, cup_pos[cup_target_pos[1]], 0.4)
				cups[2].position = lerp(cups[2].position, cup_pos[cup_target_pos[2]], 0.4)
				#make and set a counter to 0
				var num = 0
				#if each of the cups are at the correct position, increase num by 1
				for i in cups.size():
					if abs(cups[i].position - cup_pos[cup_target_pos[i]]) < Vector2(0.01, 0.01):
						num += 1
				#if all of the cups are at the correct position
				if num == cups.size():
					#stop the cups from moving
					cup_moving = false
					#if there aren't any moves left, finish moving and set the selected cup
					if moves == 0:
						moving = false
						finished_moving = true
						selected_cup = 0
		#when the cups have finished moving
		if finished_moving:
			#set the button's focus
			cups[cup_target_pos.find(selected_cup)].grab_focus()
			#change the button's focus if the player pressses any directional input
			if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_up"):
				selected_cup -= 1
				if selected_cup < 0:
					selected_cup = cups.size() - 1
			if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_down"):
				selected_cup += 1
				if selected_cup >= cups.size():
					selected_cup = 0
			#if the player presses the accept button, press the button
			if Input.is_action_just_pressed("ui_accept"):
				cups[cup_target_pos.find(selected_cup)].emit_signal("pressed")
	
	#debug
	if Input.is_action_just_pressed("crawl"):
		current = true

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
