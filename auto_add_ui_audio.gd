extends Node


var playback:AudioStreamPlaybackPolyphonic


func _enter_tree() -> void:
	# Create an audio player
	var player = AudioStreamPlayer.new()
	player.bus = "UI SFX"
	add_child(player)

	# Create a polyphonic stream so we can play sounds directly from it
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	# Get the polyphonic playback stream to play sounds
	playback = player.get_stream_playback()

	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node:Node) -> void:
	if node is Button or node is TextureButton:
		# If the added node is a button we connect to its mouse_entered and pressed signals
		# and play a sound
		node.mouse_entered.connect(_play_hover)
		node.pressed.connect(_play_pressed)
		
	if node is HSlider:
		node.mouse_entered.connect(_play_hover)
		node.value_changed.connect(_play_value_changed)
		
	if node is ItemList:
		node.item_selected.connect(_play_hover_int)
		node.item_activated.connect(_play_pressed_int)
		
	if node is Game:
		node.on_die.connect(_on_die)
		node.on_gained_hp.connect(_on_gained_hp)
		node.on_lost_hp.connect(_on_lost_hp)
		
	if node is ChoicePanel:
		_on_choice()
		
func _on_die():
	var stream = playback.play_stream(preload('res://resources/sfx/die.ogg'), 0, 0, randf_range(0.9, 1.1))
	
func _on_gained_hp():
	var stream = playback.play_stream(preload('res://resources/sfx/gain_hp.ogg'), 0, 0, randf_range(0.9, 1.1))
	
func _on_lost_hp():
	var stream = playback.play_stream(preload('res://resources/sfx/lose_hp.ogg'), 0, 0, randf_range(0.9, 1.1))

func _on_choice():
	var stream = playback.play_stream(preload('res://resources/sfx/choice.ogg'), 0, 0, randf_range(0.9, 1.1))

func _play_hover_int(i: int):
	_play_hover()
	
func _play_pressed_int(i: int):
	_play_pressed()

func _play_hover() -> void:
	var stream = playback.play_stream(preload('res://resources/sfx/switch.ogg'), 0, 0, randf_range(0.9, 1.1))

func _play_pressed() -> void:
	var stream = playback.play_stream(preload('res://resources/sfx/select.ogg'), 0, 0, randf_range(0.9, 1.1))
	
func _play_value_changed(value: float) -> void:
	#var real_value = value / 100.0
	#playback.play_stream(preload('res://ui/pluck_002.ogg'), 0, 0, randf_range(real_value - 0.05, real_value + 0.05))
	pass
