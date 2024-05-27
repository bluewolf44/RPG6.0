extends ChainConditionsAttack
class_name ChainAttckMultSpeed

@export var speedMult:float

func run_effect(action:Attack,battleAction:BattleActions)->void:
	action.currentAttack *= 1+speedMult*(battleAction.get_chain_total_speed())
