extends Node

class_name ui_cursor

@export var cursor : TextureProgressBar ## The cursor node
@export var line : Line2D ## The line2d that follows the cursor
@export var first_focus : Button ## The first button that will be focussed when a key is pressed
@export var pause_screen : Node ## The pause screen for when pausing the game from a button

var positions : Dictionary #stores the default position of each button
var focus_node : Control #the node that is currently being focused
var lines : Array #stores the names of the underlines for each button

#called when this node is first instanced into the scene
func _ready():
	#hide the cursor
	cursor.hide()
	#for each of the children of the parent node
	for child in get_parent().get_children():
		#if it is a button
		if child is Button:
			#add it's position to the positions dictionary
			positions[child] = child.position
			#connect it's signals
			child.mouse_entered.connect(hover.bind(child))
			child.pressed.connect(button_pressed.bind(child))
			
			var new_line = Line2D.new()
			new_line.add_point(new_line.position + Vector2(0, 100))
			new_line.add_point(new_line.position + Vector2(0, 100))
			child.add_child(new_line)
			lines.append(new_line)

#called each process frame
func _process(_delta):
	#store the node that is currenly being focussed
	focus_node = get_viewport().gui_get_focus_owner()
	#if there isn't any node being focussed
	if !focus_node:
		#if the player presses any button, make the first focus node grab focus
		if Input.is_anything_pressed():
			first_focus.grab_focus()
	#if there is a node being focussed
	else:
		#show the cursor
		cursor.show()
		#set the position for the cursor and the line following it
		cursor.position = lerp(cursor.position, focus_node.position - Vector2(50, 0), 0.3)
		line.points[0] = cursor.position
		line.points[1] = lerp(line.points[1], cursor.position, 0.2)
		
		for button in positions.keys():
			var underline = button.get_child(0)
			if button == focus_node:
				underline.points[1] = lerp(underline.points[1], underline.points[0] + Vector2(300, 0), 0.2)
			else:
				underline.points[1] = lerp(underline.points[1], underline.points[0], 0.5)
	
	
	#for each of the buttons move them depending on where the cursor currently is
	for button in positions.keys():
		button.position.y = positions[button].y + (positions[button].y - cursor.position.y) / 2

#called when a button is pressed
func button_pressed(button):
	var command = button.editor_description #the command that the button will do when pressed
	var action_type = command.get_slice("-",1) #the type of action that the button will do when pressed
	var target = command.replace(command.get_slice("-",1),"").replace("-", "") #the target of the action
	
	#pouring cider animation
	for i in 10:
		await get_tree().process_frame
		cursor.rotation_degrees += 10
	for i in 30:
		await get_tree().process_frame
		cursor.value -= 1
	
	#if the action type is scene, change the scene to the target scene
	if action_type == "scene":
		get_tree().paused = false
		get_tree().change_scene_to_file(str("res://", target, ".tscn"))
	#if the action type is hide, toggle the visibility of the target node
	elif action_type == "hide":
		get_tree().root.get_node(target).visible = !get_tree().root.get_node(target).visible
	#if the action type is pause, toggle the current pause state of the game
	elif action_type == "pause":
		pause_screen.toggle_pause()
	#if the action type is save, save everything that the player has unlocked so far
	elif action_type == "save":
		save()
	#if the action type is load, load everything that the player unlocked in a previous save
	elif action_type == "load":
		load_data()
	
	cursor.value = 30
	cursor.rotation = 0

#called when saving the game
func save() -> void:
	#open the save file so that it can be written to
	var save_file = FileAccess.open("user://savedata.save", FileAccess.WRITE)
	#get all of the needed info that will be saved
	var data = {
		"crawl" : unlocks.crawl,
		"climb" : unlocks.climb,
		"cube 1" : unlocks.cube_1,
		"cube 2" : unlocks.cube_2,
		"cube 3" : unlocks.cube_3
	}
	var save_data = JSON.stringify(data)
	#store the data into the file
	save_file.store_line(save_data)
	#close the save file
	save_file.close()

#called when loading the game file
func load_data():
	#open the save file so it can be read
	var save_file = FileAccess.open("user://savedata.save", FileAccess.READ)
	#read each line
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var save_data = json.get_data()
		for i in save_data.keys():
			unlocks.set(i, save_data[i])
	#close the save file
	save_file.close()

#called when the mouse enters a button
func hover(button):
	#make the button grab focus
	button.grab_focus()
