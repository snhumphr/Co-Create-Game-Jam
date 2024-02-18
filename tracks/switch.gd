class_name Switch extends Node2D

enum Directions {NORTH, EAST, SOUTH, WEST}
@export var direction:Directions = Directions.NORTH
@onready var arrow:Sprite2D = $Sprite2D

func _ready():
	pass


func _process(delta):
	match direction:
		Directions.NORTH:
			arrow.rotation_degrees = 0
		Directions.EAST:
			arrow.rotation_degrees = 90
		Directions.SOUTH:
			arrow.rotation_degrees = 180
		Directions.WEST:
			arrow.rotation_degrees = 270


func get_point(step:float):
	var point:Vector2 = global_position
	match direction:
		Directions.NORTH:
			point.y -= step
		Directions.EAST:
			point.x += step
		Directions.SOUTH:
			point.y += step
		Directions.WEST:
			point.x -= step
	return point


func _on_mouse_collision_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			match direction:
				Directions.NORTH:
					direction = Directions.EAST
				Directions.EAST:
					direction = Directions.SOUTH
				Directions.SOUTH:
					direction = Directions.WEST
				Directions.WEST:
					direction = Directions.NORTH
