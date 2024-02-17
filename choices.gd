extends PanelContainer

func init(event: Event):
	
	var choices = self.get_node("layout/choices")
	
	for choice in event.choice_list:
		choices.add_item(choice.text)
		
	return choices
