extends Control

var controlEntities = []
var nonControlEntities = []

var selected:Entitie
enum EVENT_SET {INFO,SELECT,ACTION}
var currentEvent:EVENT_SET
var currentTurn:int = 1

var currentActionSelection:Action
var currentTargets:Array[Entitie]

var battleActions = []

func _ready() -> void:
	#readyBattle(Data.party,[load("res://AutoLoad/Spider.tres")])
	readyBattle(Data.party,[load("res://AutoLoad/Dryad.tres"),load("res://AutoLoad/Spider.tres")])

func readyBattle(party:Array,enemies:Array) -> void:
	currentEvent = EVENT_SET.INFO
	
	for p in party:
		var entitie = ControlEntitie.new(p,self)
		entitie.createSelf(normal_add_left(party.size(),controlEntities.size()))
		controlEntities.append(entitie)
	
	for e in enemies:
		var entitie = NonControlEntitie.new(e,self)
		entitie.createSelf(normal_add_right(enemies.size(),nonControlEntities.size()))
		nonControlEntities.append(entitie)
		
	create_non_control_entitie_attacks()

func create_non_control_entitie_attacks():
	for entitie in nonControlEntities:
		
		addBattleAction(BattleActions.new(entitie,[controlEntities.pick_random()],entitie.data.actions.pick_random(),self))
	update_speed_bar()
	update_chains()

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
	for entitie in controlEntities+nonControlEntities:
		entitie.set_color("ffffff")
	$PanelContainer/MarginContainer/VBoxContainer.visible = false
	selected = null

func back_ground_click(event:InputEvent):
	if currentEvent == EVENT_SET.INFO:
		if event.is_action_released("LMB") or event.is_action_released("RMB"):
			if selected != null:
				clear_selected()
			#print(event)
	elif currentEvent == EVENT_SET.SELECT:
		if event.is_action_released("RMB"):
			clearSlection()

func createSelections(entities:Array,action:Action):
	currentEvent = EVENT_SET.SELECT
	currentActionSelection = action
	currentTargets = []
	for entitie in entities:
		entitie.set_color("ddd41f")

func addTarget(entitie:Entitie):
	currentTargets.append(entitie)
	if currentActionSelection.maxNumberOfTargets == currentTargets.size():
		addBattleAction(BattleActions.new(selected,currentTargets,currentActionSelection,self))
		update_speed_bar()
		update_chains()
		clearSlection()

func clearSlection():
	currentEvent = EVENT_SET.INFO
	currentActionSelection = null
	selected = null
	$PanelContainer/MarginContainer/VBoxContainer.visible = false
	currentTargets = []
	for entitie in controlEntities + nonControlEntities:
		entitie.set_color("ffffff")

func addBattleAction(action:BattleActions):
	action.entitie.currentPoints -= action.action.cost
	action.entitie.current_actions.append(action)
	var n = 0
	var found = false
	while n < battleActions.size():
		if battleActions[n][0].speed == action.speed:
			found = true
			battleActions[n].append(action)
			break
		elif battleActions[n][0].speed > action.speed:
			battleActions.insert(n,[action])
			found = true
			break
		n+=1
	
	if !found:
		battleActions.append([action])

func setCorretCenter(sprite:TextureRect) -> Vector2:
	return sprite.size*sprite.scale/2

func update_chains() -> void:
	for chain in $SpeedBar/ChainTexs.get_children():
		chain.queue_free()
	
	var chain_actions:Array[BattleActions]
	var current_team:String = ""
	var start_postion_x:int

	for action_speed in battleActions:
		var is_same:bool = true
		for action in action_speed:
			if current_team == "":
				current_team = action.entitie.get_team()
				start_postion_x = action.tex_speed.position.x+setCorretCenter(action.tex_speed).x
				
			elif action.entitie.get_team() != current_team:
				if chain_actions.size() > 1 and chain_actions[0].speed != chain_actions[-1].speed:
					create_chain(start_postion_x,chain_actions[-1].tex_speed.position.x+setCorretCenter(chain_actions[-1].tex_speed).x,"10dfdf")
				is_same = false
				current_team = ""
				break
			
		if !is_same:
			for action in action_speed:
				chain_actions = []
				chain_actions.append(action)
				action.chain_actions = chain_actions
			chain_actions = []
			current_team = ""
		else:
			for action in action_speed:
				chain_actions.append(action)
				action.chain_actions = chain_actions
	if current_team != "" and chain_actions.size() > 1 and chain_actions[0].speed != chain_actions[-1].speed:
		create_chain(start_postion_x,chain_actions[-1].tex_speed.position.x+setCorretCenter(chain_actions[-1].tex_speed).x,"10dfdf")

func create_chain(start_postion_x:int,end_postion_x:int,color:Color):
	for n in range((end_postion_x-start_postion_x)/32+1):
		var tex_rect = TextureRect.new()
		tex_rect.position = Vector2(n*32+start_postion_x,0)
		tex_rect.texture = preload("res://sprites/Chain.png")
		tex_rect.modulate = color
		$SpeedBar/ChainTexs.add_child(tex_rect)

func update_speed_bar() -> void:
	var min_value = battleActions[0][0].speed
	var max_value = battleActions[-1][0].speed
	$SpeedBar/ProgressBar.min_value = min_value-2
	$SpeedBar/ProgressBar.max_value = max_value+2
	$SpeedBar/ProgressBar.value = min_value-2
	
	if min_value == max_value:
		var y:int = 32
		for n in range(len(battleActions[0])):
			battleActions[0][n].tex_speed.position = Vector2(500-setCorretCenter(battleActions[0][n].tex_speed).x,y)
			y += setCorretCenter(battleActions[0][n].tex_speed).y*2
	else:
		var last_speed = 0
		for actions in battleActions:
			var totalY = 0
			for n in range(len(actions)):
				actions[n].tex_speed.position = Vector2(1000/(max_value-min_value+4)*(actions[n].speed-min_value+2)-setCorretCenter(actions[n].tex_speed).x,totalY)
				totalY += setCorretCenter(actions[n].tex_speed).y*2

func start_actions() -> void:
	var current_chain_size:int = 0
	for action_speed in battleActions: 
		$SpeedBar/ProgressBar.value = action_speed[0].speed
		action_speed.shuffle()
		for action in action_speed:
			if current_chain_size == 0:
				current_chain_size = action.chain_actions.size()
			current_chain_size-=1
			await action.use_action()
			if current_chain_size == 0:
				await get_tree().create_timer(2.0).timeout
			else:
				await get_tree().create_timer(0.2).timeout
	
	$SpeedBar/ProgressBar.value = $SpeedBar/ProgressBar.max_value
	await get_tree().create_timer(0.2).timeout
	
	for speedAction in battleActions:
		for action in speedAction:
			action.tex_speed.queue_free()
	
	battleActions.clear()
	$SpeedBar/ProgressBar.value = $SpeedBar/ProgressBar.min_value
	
	currentTurn += 1
	for e in controlEntities + nonControlEntities:
		e.currentPoints = e.data.actionPointsPerTurn + int(currentTurn/2)
		e.current_actions.clear()
	create_non_control_entitie_attacks()
	
	
