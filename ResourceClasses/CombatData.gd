class_name CombatData
extends Resource

@export var entitieName:String
@export var texture:Texture
@export var scale:Vector2

@export var baseSpeed:int
@export var maxHealth:int
var currentHealth:int
@export var baseDef:int
var currentDef:int
@export var actionPointsStart:int
@export var actionPointsPerTurn:int
var currentPoints:int

@export var actions:Array[Action]
