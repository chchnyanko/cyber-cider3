extends Node

class_name ui_cursor

@export var cursor : Sprite2D
@export var line : Line2D
@export var first_focus : Button
@export var pause_screen : Node

var positions : Dictionary
var focus_node : Control

func _ready():
	for child in get_parent().get_children():
		if child is Button:
			positions[child] = child.position
			child.mouse_entered.connect(hover.bind(child))
			child.pressed.connect(button_pressed.bind(child))

func _process(_delta):
	focus_node = get_viewport().gui_get_focus_owner()
	if !focus_node:
		if Input.is_anything_pressed():
			first_focus.grab_focus()
	else:
		cursor.show()
		cursor.position = lerp(cursor.position, focus_node.position - Vector2(50, 0), 0.3)
		line.points[0] = cursor.position
		line.points[1] = lerp(line.points[1], cursor.position, 0.2)
	
	for button in positions.keys():
		button.position.y = positions[button].y + (positions[button].y - cursor.position.y) / 2

func button_pressed(button):
	var text = button.editor_description
	var slice = text.get_slice("-",1)
	var target = text.replace(text.get_slice("-",1),"").replace("-", "")
	if slice == "scene":
		get_tree().paused = false
		get_tree().change_scene_to_file(str("res://",target,".tscn"))
	elif slice == "hide":
		get_tree().root.get_node(target).visible = !get_tree().root.get_node(target).visible
	elif slice == "pause":
		pause_screen.toggle_pause()

func hover(button):
	button.grab_focus()
