extends Node2D

@onready var bass: AudioStreamPlayer = $Tracks/Bass
@onready var bass_pluck: AudioStreamPlayer = $"Tracks/Bass Pluck"
@onready var tubes: AudioStreamPlayer = $Tracks/Tubes
@onready var claps: AudioStreamPlayer = $Tracks/Claps
@onready var plucks: AudioStreamPlayer = $Tracks/Plucks
@onready var banjo: AudioStreamPlayer = $Tracks/Banjo
@onready var choir: AudioStreamPlayer = $Tracks/Choir
@onready var acoustic_guitar: AudioStreamPlayer = $"Tracks/Acoustic Guitar"
@onready var piano: AudioStreamPlayer = $Tracks/Piano

# Called when the node enters the scene tree for the first time.
func _ready():
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
	pass
