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
			#set the randomised colour for each button
			randomize()
			colours[i] = Color(randf_range(0, 0.4),randf_range(0, 0.4),randf_range(0, 0.4))

#called every process frame
func _process(delta):
	#if there is a button being focussed
	if get_viewport().gui_get_focus_owner():
		#set the background colour of that of the button
		$ColorRect.color = colours.get(get_viewport().gui_get_focus_owner())

#debug
func _input(event):
	if event.is_action("crawl"):
		change_colour()
