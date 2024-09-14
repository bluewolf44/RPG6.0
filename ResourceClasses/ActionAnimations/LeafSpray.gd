extends ActionAnimation
class_name LeafSpray

func run(entitie:Entitie,targets:Array[Entitie]):
	var tex = entitie.sprite
	var scene = load("res://AnimatonScenes/LeafSpray.tscn").instantiate()
	tex.add_child(scene)
	scene.position += Vector2(-tex.get_rect().size.x/2,-20)
	
	for t in targets:
		var target = t.sprite
		while tex.position.distance_to(target.position) > 10+target.texture.get_size().x*target.scale.x/2+tex.texture.get_size().x*tex.scale.x/2:
			tex.position = tex.position.move_toward(target.position,30)
			await tex.get_tree().process_frame
		for n in range(3):
			scene.restart()
			await scene.finished
			
		for n in range(10):
			await tex.get_tree().process_frame
		scene.free()
	
	await reset(entitie,targets)
		
	
