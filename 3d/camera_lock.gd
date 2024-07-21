extends Area3D

@export var pos : Vector3 ## The position that the camera will be locked in
@export var angle_rad : Vector3 ## The angle of the camera when locked

#called when a body enters the area
func _on_body_entered(body):
	#if the body is player, set camera state to lock and set the lock position and angle
	if body.name == "player":
		body.camera.change_state("lock")
		body.camera.lock_pos = pos
		body.camera.lock_angle = angle_rad

#called when a body exits the area
func _on_body_exited(body):
	#if the body is player, unlock the camera
	if body.name == "player":
		body.camera.change_state("unlock")
