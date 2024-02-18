extends Control

var events_dict = {}
var counter = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	
	load_events("res://resources/events", events_dict)
	display_choice(events_dict[50])

func load_events(path: String, dict: Dictionary):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var event = load(path + "/" + file_name)
				if not dict.has(event.id):
					dict[event.id] = event
				else:
					printerr("Error, duplicate id detected: " + str(event.id))
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
	
	get_tree().call_group("event", "queue_free")
	
	var choice = event.choice_list[index]
	var effect_list = choice.effect_list
	var next_event_id = choice.next_event_id
	
	for effect in effect_list:
		apply_effect(effect)
		
	if next_event_id > -1:
		display_choice(events_dict[next_event_id])
	elif false:
		counter +=1
		display_choice(events_dict[counter])
