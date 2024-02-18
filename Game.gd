extends Control

var events_dict = {}
var counter = 50

var train_max_hp = 3
var train_hp = 3

var train_speed = 200.0

var ingredients_dict = {
	"First": false,
	"Second": false,
	"Third": false
}

var upgrade_dict = {
	Choice.Upgrade.blank: true,
	Choice.Upgrade.snailRepellant: false,
	Choice.Upgrade.waterproofCoating: false,
	Choice.Upgrade.kingsSigil: false,
	Choice.Upgrade.railLayingMachine: false,
	Choice.Upgrade.medicalCar: false,
	Choice.Upgrade.highMorale: false
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	load_events("res://resources/events", events_dict)
	
	print(upgrade_dict)
	
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
	
	var choices = instance.init(event, upgrade_dict)
	choices.item_activated.connect(_on_choices_item_activated.bind(event))
	
func apply_effect(effect: GlobalDataSingle.Effect, upgrade: Choice.Upgrade):
	
	var keys = ingredients_dict.keys()
	
	match effect:
		GlobalDataSingle.Effect.damageTrain:
			change_train_hp(-1)
		GlobalDataSingle.Effect.repairTrain:
			if train_hp < train_max_hp:
				change_train_hp(1)
		GlobalDataSingle.Effect.collectFirstIngredient:
			ingredients_dict[keys[0]] = true
		GlobalDataSingle.Effect.collectSecondIngredient:
			ingredients_dict[keys[1]] = true
		GlobalDataSingle.Effect.collectThirdIngredient:
			ingredients_dict[keys[2]] = true
		GlobalDataSingle.Effect.collectRandomIngredient:
			var pick_array = []
			for key in keys:
				if not ingredients_dict[key]:
					pick_array.append(key)
			if pick_array.length > 0:
				ingredients_dict[pick_array.pick_random()] = true
		GlobalDataSingle.Effect.applyUpgrade:
			upgrade_dict[upgrade] = true
		GlobalDataSingle.Effect.removeUpgrade:
			if not upgrade == Choice.Upgrade.blank:
				upgrade_dict[upgrade] = false
		GlobalDataSingle.Effect.applyRandomUpgrade:
			var rng = randi_range(1, upgrade_dict.keys().size())
			upgrade_dict[rng] = true
		GlobalDataSingle.Effect.removeRandomUpgrade:
			var rng = randi_range(1, upgrade_dict.keys().size())
			upgrade_dict[rng] = false
		_:
			printerr("Effect not recognized: " + str(effect))
	
func _on_choices_item_activated(index: int, event: Event):
	
	get_tree().call_group("event", "queue_free")
	
	var choice = event.choice_list[index]
	var effect_list = choice.effect_list
	var next_event_id = choice.next_event_id
	
	for effect in effect_list:
		apply_effect(effect, choice.upgrade)
		
	if next_event_id > -1:
		display_choice(events_dict[next_event_id])
	elif false:
		counter +=1
		display_choice(events_dict[counter])

func change_train_hp(change: int):
	train_hp += change
	var hp_bar = self.get_node("UI/ProgressBar")
	hp_bar.set_value(train_hp)
	if train_hp == 0:
		pass #TODO: End the game
