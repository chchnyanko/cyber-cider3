extends Node2D

func _on_setting_1_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
