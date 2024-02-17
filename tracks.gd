extends Node2D

@onready var nodes = $TrackNodes.get_children()
@onready var train = $TrainCar
@onready var agent = train.get_node("NavigationAgent2D")
var movespeed:float = 200.0
var goto_node = 0


func _ready():
	train.global_position = nodes[0].global_position
	call_deferred("wait_for_navserver")


func wait_for_navserver():
	await get_tree().physics_frame
	agent.target_position = nodes[goto_node].global_position


func _physics_process(delta):
	if agent.is_navigation_finished():
		goto_node += 1
		if goto_node >= nodes.size():
			goto_node = 0
		print("going to ", goto_node)
		agent.target_position = nodes[goto_node].global_position
	train.velocity = train.global_position.direction_to(agent.get_next_path_position()) * movespeed
	train.move_and_slide()
