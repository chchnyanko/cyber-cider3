extends Control

var colours : Dictionary #stores the node and Color for each button

#called when this scene is first instanced
func _ready():
	#change the random colours
	change_colour()

#called when the colours for each button should be changed
func change_colour():
	#for all of the children of this node
	for i in get_children():
		#if it is a button
		if i is Button:
			#connect the mouse entered signal
			i.mouse_entered.connect(hover.bind(i))
			#set the randomised colour for each button
			randomize()
			colours[i] = Color(randf_range(0, 0.4),randf_range(0, 0.4),randf_range(0, 0.4))

#called when the mouse enters each button
func hover(button):
	#change the background colour to the random colour set in change colour
	$ColorRect.color = colours.get(button)

#debug
func _input(event):
	if event.is_action("crawl"):
		change_colour()
