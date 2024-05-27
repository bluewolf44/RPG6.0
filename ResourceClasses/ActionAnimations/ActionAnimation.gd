extends Resource
class_name ActionAnimation

func run(entitie:Entitie,targets:Array[Entitie]) -> void:
	pass

func reset(entitie:Entitie,targets:Array[Entitie]) -> void:
	
	var not_at_base:int = 1+targets.size()
	
	while not_at_base != 0:
		for e in [entitie]+targets:
			if e.sprite.position == e.base_posistion:
				continue
			e.sprite.position = e.sprite.position.move_toward(e.base_posistion,30)
			if e.sprite.position == e.base_posistion:
				not_at_base -= 1
		await entitie.sprite.get_tree().process_frame
