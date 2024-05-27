class_name Action
extends Resource

enum TARGETS_TYPES {SELF,TEAM,ENEMIES,ANY}

@export var actionName:String
@export var targetsType:TARGETS_TYPES
@export var maxNumberOfTargets:int#-1 for all
@export var minNumberOfTargets:int#-1 for all
@export var cost:int
@export var speedMult:float
@export var next:Action
@export var actionAnimation:ActionAnimation

func runAction(battleAction:BattleActions) -> void:
	print(actionName+" has not be made")
