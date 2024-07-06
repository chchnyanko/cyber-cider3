extends Node2D

@onready var card = $card
@onready var timer = $Timer

var current : bool = false #set to true if this is the minigame that is currently being played

var mouse_entered : bool = false

var clicked : bool = false

var card_entered : bool = false #if the card is in the swiper

func _on_card_mouse_entered():
	mouse_entered = true

func _on_card_mouse_exited():
	mouse_entered = false

func _process(delta):
	if current:
		if mouse_entered:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				clicked = true
			else:
				clicked = false
		if clicked:
			card.position = lerp(card.position, get_viewport().get_mouse_position(), 0.5)
	$TextureProgressBar.value = timer.time_left

func _on_card_swiper_area_exited(area):
	if area.name == "card":
		card_entered = false
		timer.stop()

func _on_card_enter_area_entered(area):
	if area.name == "card":
		card_entered = true
		var rand = randf_range(1, 1.5)
		timer.start(rand)
		$TextureProgressBar.max_value = rand

func _on_card_exit_area_entered(area):
	if area.name == "card":
		if card_entered:
			if timer.time_left < 0.5 and timer.time_left != 0:
				win()

func win():
	print("you win")
