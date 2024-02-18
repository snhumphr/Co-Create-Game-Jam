extends Node2D

@export var escape: MusicChange
@export var enter: MusicChange

@export var left: MusicChange
@export var right: MusicChange

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		MusicPlayer.instance.receive_music_change(enter)
		
	if Input.is_action_just_pressed("ui_cancel"):
		MusicPlayer.instance.receive_music_change(escape)
		
	if Input.is_action_just_pressed("ui_left"):
		MusicPlayer.instance.receive_music_change(left)
		
	if Input.is_action_just_pressed("ui_right"):
		MusicPlayer.instance.receive_music_change(right)
