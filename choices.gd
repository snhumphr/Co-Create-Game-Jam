extends PanelContainer

func init(event: Event):
	
	var description = self.get_node("layout/description")
	
	var title = "[center]" + "[b]" + event.name + "[/b]" + "[/center]" + "\n" + "\n"
	description.append_text(title)
	description.append_text("[p]" + event.description + "[/p]")
	
	var choices = self.get_node("layout/choices")
	
	for choice in event.choice_list:
		choices.add_item(choice.text)
		
	return choices
