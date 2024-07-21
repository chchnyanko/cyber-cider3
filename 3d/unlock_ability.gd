extends Label

@onready var animation: AnimationPlayer = $AnimationPlayer #reference to the animation player

#called when the player collects a new ability
func unlock_ability(ability: String) -> void:
	#set the text on this label
	text = str("Unlocked New Ability: 
	", ability)
	#actually unlock the new ability
	unlocks.set(ability, true)
	#show the text in the animation
	animation.play("new_ability")
