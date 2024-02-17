extends Control

var events_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	load_events("res://resources/events", events_list)
	display_choice(events_list[0])

func load_events(path: String, list: Array):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				list.append(load(path + "/" + file_name))
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		printerr("An error occurred when trying to access the path.")

func display_choice(event: Event):
	
	var scene = load("res://choice.tscn")
	var instance = scene.instantiate()
	self.add_child(instance)
	
	var event_list = []
	
	var choices = instance.init(event)
	choices.item_activated.connect(_on_choices_item_activated.bind(event))
	
func apply_effect(effect: GlobalDataSingle.Effect):
	
	match effect:
		_:
			printerr("Effect not recognized: " + str(effect))
	
func _on_choices_item_activated(index: int, event: Event):
	
	var effect_list = event.choice_list[index].effect_list
	
	for effect in effect_list:
		apply_effect(effect)
