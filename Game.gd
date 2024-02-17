extends Control

var events_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
	display_choice()

func display_choice():
	
	var scene = load("res://choice.tscn")
	var instance = scene.instantiate()
	self.add_child(instance)
	
	var event_list = []
	
	var river_event = Event.new()
	river_event.description = "the rail ahead has been submerged by a river, blocking the easy path"
	var ford_river = Choice.new()
	ford_river.text = "ford the river with your train"
	ford_river.effect_list.append(GlobalDataSingle.Effect.damageTrain)
	var go_around = Choice.new()
	go_around.text = "go around, daring the mists"
	go_around.effect_list.append(GlobalDataSingle.Effect.triggerHunter)
	
	river_event.choice_list.append(ford_river)
	river_event.choice_list.append(go_around)
	
	var choices = instance.init(river_event)
	choices.item_activated.connect(_on_choices_item_activated.bind(river_event))
	
func apply_effect(effect: GlobalDataSingle.Effect):
	
	match effect:
		_:
			printerr("Effect not recognized: " + str(effect))
	
func _on_choices_item_activated(index: int, event: Event):
	
	var effect_list = event.choice_list[index].effect_list
	
	for effect in effect_list:
		apply_effect(effect)
