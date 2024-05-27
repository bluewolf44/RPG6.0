extends ChainConditionsAttack
class_name ChainAttckAddionDamage

@export var atSetSpeed:int
@export var addionDamage:float

func run_effect(action:Attack,battleAction:BattleActions)->void:
	if battleAction.get_chain_total_speed() >= atSetSpeed:
		action.currentAttack += addionDamage
