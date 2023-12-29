extends Control

var controlEntities = []
var nonControlEntities = []
var selected:Entitie
var selected_action:String

class Entitie:
	var tex_rect:TextureRect
	var tex_speed:TextureRect
	var data:CombatData
	var main:Control
	
	func _init(data:CombatData,main:Control) -> void:
		self.data = data
		self.main = main
	
	func createSelf(placement:Vector2) -> void:
		tex_rect = TextureRect.new()
		tex_rect.texture = data.texture
		tex_rect.scale = data.scale
		tex_rect.mouse_filter = Control.MOUSE_FILTER_STOP
		tex_rect.position = placement
		tex_rect.gui_input.connect(select)
		main.get_node("EntitiesTextures").add_child(tex_rect)
		
		tex_speed = TextureRect.new()
		tex_speed.texture = data.texture
		tex_speed.scale = data.scale/2
		main.get_node("SpeedBar/EntitesSpeeds").add_child(tex_speed)
	
	func select(inputEvent:InputEvent) -> void:
		pass

class ControlEntitie extends Entitie:
	func select(inputEvent:InputEvent) -> void:
		if inputEvent.is_action("LMB"):
			if main.selected == self:
				return
			if main.selected != null:
				main.clear_selected()
			
			main.selected = self
			tex_rect.self_modulate = "3fc4ff"
			tex_speed.self_modulate = "3fc4ff"
			main.get_node("PanelContainer/MarginContainer/VBoxContainer").visible = true

class NonControlEntitie extends Entitie:
	func select(inputEvent:InputEvent) -> void:
		if inputEvent.is_action("LMB"):
			if main.selected == self:
				return
			if main.selected != null:
				main.clear_selected()
			main.selected = self
			tex_rect.self_modulate = "c94776"
			tex_speed.self_modulate = "c94776"
			main.get_node("PanelContainer/MarginContainer/VBoxContainer").visible = true

func _ready() -> void:
	print("test")
	readyBattle(Data.party,Data.party)

func readyBattle(party:Array,enemies:Array) -> void:
	for p in party:
		var entitie = ControlEntitie.new(p,self)
		entitie.createSelf(normal_add_left(party.size(),controlEntities.size()))
		controlEntities.append(entitie)
	
	for e in enemies:
		var entitie = NonControlEntitie.new(e,self)
		entitie.createSelf(normal_add_right(enemies.size(),nonControlEntities.size()))
		nonControlEntities.append(entitie)

func normal_add_left(total:int,number:int) -> Vector2:
	if number >= total or total > 5 or number < 0:
		return Vector2(-1,-1)
	return [
			[
				Vector2(150,320),
			],
			[
				Vector2(170,170),
				Vector2(170,420),
			],
			[
				Vector2(110,170),
				Vector2(270,295),
				Vector2(110,420),
			],
			[
				Vector2(270,160),
				Vector2(110,250),
				Vector2(110,390),
				Vector2(270,480),
			],
			[
				Vector2(270,160),
				Vector2(110,250),
				Vector2(110,390),
				Vector2(270,480),
				Vector2(270,320),
			],
		][total-1][number]

func normal_add_right(total:int,number:int) -> Vector2:
	if number >= total or total > 5 or number < 0:
		return Vector2(-1,-1)
	return [
			[
				Vector2(850,320),
			],
			[
				Vector2(800,170),
				Vector2(800,420),
			],
			[
				Vector2(900,170),
				Vector2(800,295),
				Vector2(900,420),
			],
			[
				Vector2(800,160),
				Vector2(900,250),
				Vector2(900,390),
				Vector2(800,480),
			],
			[
				Vector2(850,160),
				Vector2(900,250),
				Vector2(900,390),
				Vector2(850,480),
				Vector2(850,320),
			],
		][total-1][number]

func clear_selected():
	selected.tex_rect.self_modulate = "ffffff"
	selected.tex_speed.self_modulate = "ffffff"
	$PanelContainer/MarginContainer/VBoxContainer.visible = false
	selected = null


func back_ground_click(event):
	if event.is_action("LMB"):
		if selected != null:
			clear_selected()
		#print(event)
