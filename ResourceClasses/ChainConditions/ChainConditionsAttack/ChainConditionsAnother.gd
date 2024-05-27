extends Resource
class_name ChainConditionsAnother

@export var atSetSpeed:int
@export var action:Action

func run_effect(action:Attack,battleAction:BattleActions)->void:
	if battleAction.get_chain_total_speed() >= atSetSpeed:
		var looping_action = action
		while looping_action.next != null:
			looping_action = looping_action.next
		looping_action.next = action
