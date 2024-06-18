extends Node2D


@onready var cursor = $Sprite2D
@onready var line = $Line2D


var positions : Dictionary
var focus_node : Control


func _ready():
	for child in get_children():
		if child is Button:
			positions[child] = child.position


func _process(_delta):
	focus_node = get_viewport().gui_get_focus_owner()
	if !focus_node:
		if Input.is_anything_pressed():
			$Start_game.grab_focus()
	else:
		cursor.show()
		cursor.position = lerp(cursor.position, focus_node.position - Vector2(50, 0), 0.3)
		line.points[0] = cursor.position
		line.points[1] = lerp(line.points[1], cursor.position, 0.2)
	
	for button in positions.keys():
		button.position = positions[button] + (positions[button] - cursor.position)
		print(button.name, positions[button], button.position)


func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://3d/level.tscn")


func _on_minigames_pressed():
	get_tree().change_scene_to_file("res://minigames/cube/cube.tscn")


func _on_settings_pressed():
	pass
	#get_tree().change_scene_to_file("res://ui/settings.tscn")


func _on_start_game_mouse_entered():
	$Start_game.grab_focus()


func _on_minigames_mouse_entered():
	$Minigames.grab_focus()


func _on_settings_mouse_entered():
	$Settings.grab_focus()
