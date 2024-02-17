extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	init() #temporary

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init():
	
	var choices = self.get_node("layout/choices")
	choices.add_item("ford the river with your train")
	choices.add_item("go around the river, like a boring person")
