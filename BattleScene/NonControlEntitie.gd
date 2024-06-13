extends Entitie

class_name NonControlEntitie

func select(inputEvent:InputEvent) -> void:
	if inputEvent.is_action_released("LMB"):
		if main.currentEvent == main.EVENT_SET.INFO:
			if main.selected == self:
				return
			if main.selected != null:
				main.clear_selected()
			main.selected = self
			set_color(getColor())
			for action in current_actions:
				for entitie in action.targets:
					entitie.set_color("ddd41f")
			
			
			var actionBar = main.get_node("PanelContainer/MarginContainer/VBoxContainer")
			actionBar.visible = true
		
			actionBar.get_node("Text/Label2").text = str(currentHealth)
			actionBar.get_node("ActionPointsBar/ActionPoints").custom_minimum_size = Vector2(34*currentPoints,34)
			actionBar.get_node("ActionPointsBar/ActionPoints2").custom_minimum_size = Vector2(34*(10-currentPoints),34)
			
			for node in actionBar.get_node("HBoxContainer").get_children():
				node.visible = false
			
		elif main.currentEvent == main.EVENT_SET.SELECT:
			main.addTarget(self)

func get_team() -> String:
	return "NonControl"

func getColor() -> Color:
	return Color("c94776")
