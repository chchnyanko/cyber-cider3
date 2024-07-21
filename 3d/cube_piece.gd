extends Area3D

@export_range(0, 3) var cube: int = 0 ## The cube that this will unlock a piece for (set to 0 for none)
@export_range(0, 6) var piece: int = 0 ## The piece of that cube that this unlocks (set to 0 for none)

#called when a body enters this node
func _on_body_entered(body: Node3D) -> void:
	#if the body is the player 
	if body.name == "player":
		pass
