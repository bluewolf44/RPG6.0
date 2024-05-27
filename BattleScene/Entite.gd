extends Object

class_name Entitie
var health:int
var sprite:Sprite2D
var current_actions = []
var data:CombatData
var main:Control
var base_posistion:Vector2

var currentDef:int
var currentPoints:int
var currentHealth:int

func _init(data:CombatData,main:Control) -> void:
	self.data = data
	self.main = main
	
	currentHealth = data.maxHealth
	currentDef = data.baseDef
	currentPoints = data.actionPointsStart

func createSelf(placement:Vector2) -> void:
	var control = Control.new()
	sprite = Sprite2D.new()
	sprite.texture = data.texture
	sprite.scale = data.scale
	sprite.position = placement

	control.size = data.texture.get_size()*data.scale
	control.mouse_filter = Control.MOUSE_FILTER_STOP
	control.position = -control.size/2
	control.gui_input.connect(select)
	sprite.add_child(control)
	main.get_node("BattleScence/EntitiesTextures").add_child(sprite)
	
	base_posistion = placement

func _to_string() -> String:
	return data.entitieName

func select(inputEvent:InputEvent) -> void:
	pass
	
func set_color(color:Color) -> void:
	sprite.self_modulate = color
	for n in current_actions:
		n.tex_speed.self_modulate = color

func play_animation() -> void:
	pass

func get_team() -> String:
	return "nan"

func getColor() -> Color:
	return Color("ffffff")

