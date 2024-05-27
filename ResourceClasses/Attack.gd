class_name Attack
extends Action

@export var baseAttack:float
var currentAttack:float
@export var defenceMult:float
@export var chainConditionsAttack:Array[ChainConditionsAttack]

func runAction(battleAction:BattleActions) -> void:
	currentAttack = baseAttack
	
	for condition in chainConditionsAttack:
		condition.run_effect(self,battleAction)
	var target_tex:Array[TextureRect] = []
	if actionAnimation != null:
		await actionAnimation.run(battleAction.entitie,battleAction.targets)
		
	
	for entitie in battleAction.targets:
		print(currentAttack-defenceMult*entitie.currentDef)
		entitie.currentHealth -= currentAttack-defenceMult*entitie.currentDef
	
	if next != null:
		next.runAction(battleAction)
	
