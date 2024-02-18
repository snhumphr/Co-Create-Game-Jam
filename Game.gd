extends Control

class_name Game

# Signals for playing the damage sfx
signal on_gained_hp
signal on_die
signal on_lost_hp

var events_dict = {}

var testing_events = false
var counter = 50

var music_player

var train_max_hp = 3
var train_hp = 1
var dead = false

var train_speed = 200.0

var ingredients_dict = {
	"Honey": false,
	"Water": false,
	"Crystal": false
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

var upgrade_names = {
	Choice.Upgrade.blank: "N/A",
	Choice.Upgrade.snailRepellant: "Snail Repellant",
	Choice.Upgrade.waterproofCoating: "Waterproof Coating",
	Choice.Upgrade.kingsSigil: "King's Sigil",
	Choice.Upgrade.railLayingMachine: "Rail Laying Machine",
	Choice.Upgrade.medicalCar: "Medical Car",
	Choice.Upgrade.highMorale: "High Morale"
}

# Called when the node enters the scene tree for the first time.
func _ready():

	load_events("res://resources/events", events_dict)

	#print(upgrade_dict)

	var scene = load("res://tracks/tracks.tscn")
	var instance = scene.instantiate()
	self.add_child(instance)

	var music_player_template = load("res://music_player.tscn")
	music_player = music_player_template.instantiate()
	self.add_child(music_player)

	var train = get_tree().get_nodes_in_group("train")[0]
	train.trigger_random_event.connect(_on_trigger_random_event)
	train.trigger_major_event.connect(_on_trigger_major_event)

	display_choice(events_dict[0])

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

	get_tree().call_group("entities", "pause")

	var scene = load("res://choice.tscn")
	var instance = scene.instantiate()
	var train = get_tree().get_nodes_in_group("train")[0]
	
	self.add_child(instance)
	
	var pos = train.get_global_position() - (Vector2.ONE * 250)
	instance.set_global_position(pos)

	var music_change = MusicChange.new()
	var goodness = 0.5
	if event.bad:
		goodness -= randf_range(0.1, 0.5)
	if event.good:
		goodness += randf_range(0.1, 0.5)

	music_player.receive_music_change(music_change)

	var choices = instance.init(event, upgrade_dict)
	choices.item_activated.connect(_on_choices_item_activated.bind(event))

func display_event_result(result_text: Array):

	var scene = load("res://choice.tscn")
	var instance = scene.instantiate()
	var train = get_tree().get_nodes_in_group("train")[0]
	
	self.add_child(instance)
	
	var pos = train.get_global_position() - (Vector2.ONE * 250)
	instance.set_global_position(pos)

	var event = events_dict[999]
	event.description = ""
	for text in result_text:
		event.description += text

	var choices = instance.init(event, upgrade_dict)
	choices.item_activated.connect(_on_choices_item_activated.bind(event))

func apply_effect(effect: GlobalDataSingle.Effect, upgrade: Choice.Upgrade):

	var keys = []
	var remove = effect == GlobalDataSingle.Effect.removeRandomUpgrade

	for key in upgrade_dict.keys():
		if upgrade_dict[key] == remove:
			keys.append(key)

	match effect:
		GlobalDataSingle.Effect.triggerHunter:
			#TODO: if we don't have time to implement the snail, just apply slow
			return apply_effect(GlobalDataSingle.Effect.slowTrain, upgrade)
		GlobalDataSingle.Effect.speedTrain:
			#TODO: Implement train slowing and speeding effects
			return "[color=green]The train's speed increases![/color]"
		GlobalDataSingle.Effect.slowTrain:
			return "[color=red]The train's speed decreases...[/color]"
		GlobalDataSingle.Effect.damageTrain:
			change_train_hp(-1)
			return "[color=red]The train was damaged![/color]"
		GlobalDataSingle.Effect.repairTrain:
			if train_hp < train_max_hp:
				change_train_hp(1)
				return "[color=green]The train was repaired![/color]"
			else:
				return "The train could not benefit from more repairs."
		GlobalDataSingle.Effect.collectFirstIngredient:
			ingredients_dict[ingredients_dict.keys()[0]] = true
			return "[color=green]" + ingredients_dict.keys()[0] + " found![/color]"
		GlobalDataSingle.Effect.collectSecondIngredient:
			ingredients_dict[ingredients_dict.keys()[1]] = true
			return "[color=green]" + ingredients_dict.keys()[1] + " found![/color]"
		GlobalDataSingle.Effect.collectThirdIngredient:
			ingredients_dict[ingredients_dict.keys()[2]] = true
			return "[color=green]" + ingredients_dict.keys()[2] + " found![/color]"
		GlobalDataSingle.Effect.collectRandomIngredient:
			var pick_array = []
			for key in ingredients_dict.keys():
				if not ingredients_dict[key]:
					pick_array.append(key)
			if pick_array.size() > 0:
				ingredients_dict[pick_array.pick_random()] = true
				return "[color=green]" + pick_array.pick_random() + " found![/color]"
		GlobalDataSingle.Effect.applyUpgrade:
			if not upgrade_dict[upgrade]:
				return "[color=green]" + upgrade_names[upgrade] + " upgrade applied![/color]"
				upgrade_dict[upgrade] = true
			else:
				return apply_effect(GlobalDataSingle.Effect.repairTrain, upgrade)
		GlobalDataSingle.Effect.removeUpgrade:
			if not upgrade == Choice.Upgrade.blank:
				upgrade_dict[upgrade] = false
				return "[color=red]" + upgrade_names[upgrade] + " upgrade removed...[/color]"
		GlobalDataSingle.Effect.applyRandomUpgrade:
			if keys.size() > 0:
				return apply_effect(GlobalDataSingle.Effect.applyUpgrade, keys.pick_random())
			else:
				return apply_effect(GlobalDataSingle.Effect.repairTrain, upgrade)
		GlobalDataSingle.Effect.removeRandomUpgrade:
			if keys.size() > 0:
				return apply_effect(GlobalDataSingle.Effect.removeUpgrade, keys.pick_random())
		GlobalDataSingle.Effect.endGame:
			get_tree().quit()
		_:
			printerr("Effect not recognized: " + str(effect))

func _on_choices_item_activated(index: int, event: Event):

	get_tree().call_group("event", "queue_free")

	var choice = event.choice_list[index]
	var effect_list = choice.effect_list
	var next_event_id = choice.next_event_id

	var result_text = [choice.result_text]

	for effect in effect_list:
		result_text.append("\n")
		result_text.append(apply_effect(effect, choice.upgrade))

	#print(result_text)

	if result_text[0] != "":
		display_event_result(result_text)
	elif next_event_id > -1:
		display_choice(events_dict[next_event_id])
	elif testing_events:
		counter += 1
		display_choice(events_dict[counter])
	elif not dead:
		get_tree().call_group("entities", "unpause")
	else:
		on_die.emit()
		display_choice(events_dict[600])

func _on_trigger_major_event(type: String):

	match type:
		"Honey":
			display_choice(events_dict[500])
		"Water":
			display_choice(events_dict[501])
		"Crystal":
			display_choice(events_dict[502])
		"Castle":
			var elixir = true
			for key in ingredients_dict.keys():
				if not ingredients_dict[key]:
					elixir = false
					break
			if elixir:
				display_choice(events_dict[700])

func _on_trigger_random_event():

	var possible_events = []

	for key in events_dict.keys():
		var event = events_dict[key]
		if event.random_event and not event.event_seen:
			possible_events.append(key)

	var chosen_event = events_dict[possible_events.pick_random()]
	#events_dict[chosen_event.id].event_seen = true

	display_choice(chosen_event)

func change_train_hp(change: int):
	train_hp += change
	var hp_bar = get_tree().get_nodes_in_group("hp_bar")[0]
	hp_bar.set_value(train_hp)
	if train_hp <= 0:
		dead = true
		
	# Emit the right sfx signal
	if change > 0:
		on_gained_hp.emit()
	elif change < 0:
		on_lost_hp.emit()
