extends PanelContainer

func init(choices_list: Array, effect_list: Array):
	
	var choices = self.get_node("layout/choices")
	
	for item in choices_list:
		choices.add_item(item)
		
	return choices
