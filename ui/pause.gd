extends Control

@onready var animation = $"../AnimationPlayer" #reference to the animation player

#called when the player pauses or unpauses the game
func toggle_pause():
	var paused = get_tree().paused #get if the game is currently paused
	#toggle the pause state
	get_tree().paused = !paused
	#player the corresponding animation
	if paused:
		animation.play("unpause")
	else:
		animation.play("pause")
	#release the focus from any node to fix an issue where you will have somthing focussed before pausing and the cursor acting unexpectedly
	var focus = get_viewport().gui_get_focus_owner()
	if focus:
		focus.release_focus()

#called when there is any input event
func _input(_event):
	#if the player presses the pause button, toggle pause
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
