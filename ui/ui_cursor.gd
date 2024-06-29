extends Node

class_name ui_cursor

@export var cursor : Sprite2D #reference to the cursor node
@export var line : Line2D #reference to the line2d that follows the cursor
@export var first_focus : Button #reference to the first button that will be focussed when a key is pressed
@export var pause_screen : Node #reference to the pause screen for when pausing the game from a button

var positions : Dictionary #stores the default position of each button
var focus_node : Control #the node that is currently being focused

#called when this node is first instanced into the scene
func _ready():
	#for each of the children of the parent node
	for child in get_parent().get_children():
		#if it is a button
		if child is Button:
			#add it's position to the positions dictionary
			positions[child] = child.position
			#connect it's signals
			child.mouse_entered.connect(hover.bind(child))
			child.pressed.connect(button_pressed.bind(child))

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
	#for each of the buttons move them depending on where the cursor currently is
	for button in positions.keys():
		button.position.y = positions[button].y + (positions[button].y - cursor.position.y) / 2

#called when a button is pressed
func button_pressed(button):
	var command = button.editor_description #the command that the button will do when pressed
	var action_type = command.get_slice("-",1) #the type of action that the button will do when pressed
	var target = command.replace(command.get_slice("-",1),"").replace("-", "") #the target of the action
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

#called when the mouse enters a button
func hover(button):
	#make the button grab focus
	button.grab_focus()
