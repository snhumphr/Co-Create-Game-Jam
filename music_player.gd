extends Node2D
class_name MusicPlayer

static var instance: MusicPlayer

@onready var bass: AudioStreamPlayer = $Tracks/Bass
@onready var bass_pluck: AudioStreamPlayer = $"Tracks/Bass Pluck"
@onready var tubes: AudioStreamPlayer = $Tracks/Tubes
@onready var claps: AudioStreamPlayer = $Tracks/Claps
@onready var plucks: AudioStreamPlayer = $Tracks/Plucks
@onready var banjo: AudioStreamPlayer = $Tracks/Banjo
@onready var choir: AudioStreamPlayer = $Tracks/Choir
@onready var acoustic_guitar: AudioStreamPlayer = $"Tracks/Acoustic Guitar"
@onready var piano: AudioStreamPlayer = $Tracks/Piano

@export var transition_speed: float = 3.0

var target_goodness: float = 1
var target_energy: float = 0.5

var current_goodness: float = 1
var current_energy: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	
	bass.play(0)
	bass_pluck.play(0)
	tubes.play(0)
	claps.play(0)
	plucks.play(0)
	banjo.play(0)
	choir.play(0)
	acoustic_guitar.play(0)
	piano.play(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_goodness = lerp(current_goodness, target_goodness, delta * transition_speed)
	current_energy = lerp(current_energy, target_energy, delta * transition_speed)
	
	piano.volume_db = frac_to_db(1.0 - current_energy)
	acoustic_guitar.volume_db = frac_to_db(current_energy)
	
func receive_music_change(change: MusicChange):
	if change.is_additive:
		set_targets(target_goodness + change.goodness, target_energy + change.energy)
	else:
		set_targets(change.goodness, change.energy)
		

func set_targets(new_goodness, new_energy):
	target_goodness = max(min(new_goodness, 1.0), 0.0)
	target_energy = max(min(new_energy, 1.0), 0.0)
	
func frac_to_db(frac: float) -> float:
	return lerp(-80, 0, frac)
