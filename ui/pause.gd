extends Control

@onready var animation = $"../AnimationPlayer"

func toggle_pause():
	var paused = get_tree().paused
	get_tree().paused = !paused
	if paused:
		animation.play("unpause")
	else:
		animation.play("pause")
	var focus = get_viewport().gui_get_focus_owner()
	if focus:
		focus.release_focus()

func _input(event):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
