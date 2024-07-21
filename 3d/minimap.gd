extends SubViewportContainer

var relative_player_pos: Vector2 #the player's position relative to the camera's viewport
var player_pos: Vector2 #the player's current position in 2D

@onready var player: player = $"../../player"

#called every process frame
func _process(delta: float) -> void:
	#get the player's position in 2D
	player_pos = Vector2(player.position.x, player.position.z)
	#calculate the relative position
	relative_player_pos = (player_pos + Vector2(100, 180)) / 200 
	#set the shader parameter to show the player's position on the map
	material.set_shader_parameter("player_pos", relative_player_pos)
