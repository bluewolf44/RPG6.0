class_name BattleActions
var entitie:Entitie
var targets:Array[Entitie]
var action:Action
var speed:float
var tex_speed:TextureRect
var main:Control
var colors:Array[Color]
var chain_actions:Array[BattleActions]

func _init(entitie:Entitie,targets:Array[Entitie],action:Action,main:Control) -> void:
	self.entitie = entitie
	self.targets = targets
	self.action = action
	self.main = main
	calulate_speed()
	
	tex_speed = TextureRect.new()
	tex_speed.texture = entitie.data.texture
	tex_speed.scale = entitie.data.scale/2 
	tex_speed.flip_h = entitie.data.hFlip
	tex_speed.mouse_entered.connect(on_moused)
	tex_speed.mouse_exited.connect(exit_mouse)
	tex_speed.gui_input.connect(selected)
	tex_speed.mouse_filter = Control.MOUSE_FILTER_STOP
	main.get_node("SpeedBar/EntitesSpeeds").add_child(tex_speed)
	
func calulate_speed() -> float:
	speed = entitie.data.baseSpeed*action.speedMult
	return speed

func selected(inputEvent:InputEvent) -> void:
	if main.currentEvent == main.EVENT_SET.INFO:
		entitie.select(inputEvent)

func on_moused()->void:
	create_lable()
	
	colors = []
	for entitie in targets:
		colors.append(entitie.sprite.self_modulate)
		entitie.set_color("ddd41f")
	entitie.set_color(entitie.getColor())
	tex_speed.self_modulate = entitie.getColor()

func use_action() ->bool:
	await action.runAction(self)
	return true

func exit_mouse()->void:
	for i in range(targets.size()):
		targets[i].set_color(colors[i])
		entitie.set_color("ffffff")
		tex_speed.self_modulate = Color("ffffff")

func create_lable()->void:
	var lable_text:Array[String] = [
		"[color=blue]Test[/color]:69",
		"Speed:"+str(speed),
		"Cost:"+str(action.cost),
	]
	var label_postion:Vector2 = tex_speed.global_position
	label_postion.x += tex_speed.size.x*tex_speed.scale.x
	
	main.get_node("ToolBar").use_label(lable_text,label_postion,tex_speed)

func _to_string() -> String:
	return "Entitie:"+str(entitie) +" Action:"+ action.actionName +" Speed:" + str(speed)

func get_chain_total_speed() -> int:
	return chain_actions[-1].speed-chain_actions[0].speed
