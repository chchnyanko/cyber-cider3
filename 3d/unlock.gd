extends Area3D

@export var ability: String ## The ability that this will unlock

#called when this node is first instanced
func _ready() -> void:
	#if the ability is already unlocked, delete this node
	if unlocks.get(ability) == true:
		queue_free()

#called when a body enters this node
func _on_body_entered(body: Node3D) -> void:
	#if the body is the player, unlock the ability and delete this node
	if body.name  == "player":
		%unlock_ability.unlock_ability(ability)
		queue_free()
