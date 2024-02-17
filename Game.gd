extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
	display_choice()

func display_choice():
	
	var scene = load("res://choice.tscn")
	var instance = scene.instantiate()
	self.add_child(instance)
	
	var choice_list = ["ford the river with your train", "go around the river, like a boring person"]
	var effect_list = []
	
	var choices = instance.init(choice_list, effect_list)
	choices.item_activated.connect(_on_choices_item_activated)
	
func _on_choices_item_activated(index):
	print(str(index))
