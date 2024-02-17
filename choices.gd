extends PanelContainer

func init(event: Event):
	
	var description = self.get_node("layout/description")
	description.append_text(event.description)
	
	var choices = self.get_node("layout/choices")
	
	for choice in event.choice_list:
		choices.add_item(choice.text)
		
	return choices
