extends Area3D

@export var pos : Vector3
@export var angle_rad : Vector3


func _on_body_entered(body):
	if body.name == "player":
		body.camera.change_state("lock")
		body.camera.lock_pos = pos
		body.camera.lock_angle = angle_rad


func _on_body_exited(body):
	if body.name == "player":
		body.camera.change_state("unlock")
