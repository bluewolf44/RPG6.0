extends Entitie

class_name ControlEntitie

func select(inputEvent:InputEvent) -> void:
	if inputEvent.is_action_released("LMB"):
		if main.currentEvent == main.EVENT_SET.INFO:
			if main.selected == self:
				return
			if main.selected != null:
				main.clear_selected()
			
			main.selected = self
			set_color("3fc4ff")
			
			var actionBar = main.get_node("PanelContainer/MarginContainer/VBoxContainer")
			actionBar.visible = true
			
			for n in actionBar.get_node("HBoxContainer").get_children():
				n.visible = false
			
			for i in data.actions.size():
				actionBar.get_node("HBoxContainer").get_child(i).visible = true
				actionBar.get_node("HBoxContainer").get_child(i).text = data.actions[i].actionName
				actionBar.get_node("HBoxContainer").get_child(i).disabled = false
				
				if data.actions[i].cost <= data.currentPoints:
					if !actionBar.get_node("HBoxContainer").get_child(i).pressed.is_connected(setTargets.bind(data.actions[i])):
						actionBar.get_node("HBoxContainer").get_child(i).pressed.connect(setTargets.bind(data.actions[i]))
				else:
					actionBar.get_node("HBoxContainer").get_child(i).disabled = true
			actionBar.get_node("Text/Label2").text = str(data.currentHealth)
			actionBar.get_node("ActionPointsBar/ActionPoints").custom_minimum_size = Vector2(34*data.currentPoints,34)
			actionBar.get_node("ActionPointsBar/ActionPoints2").custom_minimum_size = Vector2(34*(10-data.currentPoints),34)
			
		elif main.currentEvent == main.EVENT_SET.SELECT:
			pass

func setTargets(action:Action) -> void:
	match action.targetsType:
		action.TARGETS_TYPES.ENEMIES:
			main.createSelections(main.nonControlEntities,action)
		_:
			print("not added type yet")

func get_team() -> String:
	return "Control"
