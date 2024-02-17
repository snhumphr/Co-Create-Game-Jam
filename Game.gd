extends Control

enum Effect {
	layRail,
	repairRail,
	triggerHunter,
	damageTrain
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
	display_choice()

func display_choice():
	
	var scene = load("res://choice.tscn")
	var instance = scene.instantiate()
	self.add_child(instance)
	
	var choice_list = ["ford the river with your train", "go around the river, like a boring person"]
	var effect_list = [[Effect.damageTrain], [Effect.triggerHunter]]
	
	var choices = instance.init(choice_list, effect_list)
	choices.item_activated.connect(_on_choices_item_activated.bind(effect_list))
	
func apply_effect(effect: Effect):
	
	match effect:
		_:
			printerr("Effect not recognized: " + str(effect))
	
func _on_choices_item_activated(index: int, effect_list: Array):
	
	for effect in effect_list[index]:
		apply_effect(effect)
