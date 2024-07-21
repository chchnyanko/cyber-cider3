extends TextureProgressBar

#called every process frame
func _process(delta: float) -> void:
	#set the clock's time
	value = $"../../sky".time * 100
