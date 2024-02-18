extends Resource # This can be any Node type, but for your purposes you only need a resource
class_name MusicChange # This line makes the class available to other scripts

@export var goodness: float
@export var energy: float
@export var is_additive: bool
# Rest of your variables...

func _init(_goodness:= 1, _energy = 0.5, _is_additive = true):
	goodness = _goodness
	energy = _energy
	is_additive = _is_additive
