extends ActionAnimation
class_name BasicAttack

func run(entitie:Entitie,targets:Array[Entitie]) -> void:
	var tex = entitie.sprite
	for t in targets:
		var target = t.sprite
		while tex.position.distance_to(target.position) > 30+target.texture.get_size().x*target.scale.x/2+tex.texture.get_size().x*tex.scale.x/2:
			tex.position = tex.position.move_toward(target.position,30)
			await tex.get_tree().process_frame
		
		for n in range(10):
			await tex.get_tree().process_frame
		tex.position = tex.position.move_toward(target.position,40)
		for n in range(10):
			await tex.get_tree().process_frame
		for n in range(10):
			target.position = target.position.move_toward(tex.position,-5)
			await tex.get_tree().process_frame
		for n in range(3):
			await tex.get_tree().process_frame
		tex.position = tex.position.move_toward(target.position,-50)
		for n in range(40):
			await tex.get_tree().process_frame
	
	await reset(entitie,targets)
