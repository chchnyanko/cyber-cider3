extends Node2D

var current : bool = false #set to true if this is the minigame that is currently being played

func _process(delta):
	$AnimatableBody2D.position.y -= 40
