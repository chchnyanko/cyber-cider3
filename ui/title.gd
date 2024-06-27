extends Control

var colours : Dictionary

func _ready():
	change_colour()

func _input(event):
	if event.is_action("crawl"):
		change_colour()

func change_colour():
	for i in get_children():
		if i is Button:
			i.mouse_entered.connect(hover.bind(i))
			randomize()
			colours[i] = Color(randf_range(0, 0.4),randf_range(0, 0.4),randf_range(0, 0.4))

func hover(button):
	$ColorRect.color = colours.get(button)
