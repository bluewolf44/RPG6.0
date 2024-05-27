extends PanelContainer


func use_label(text:Array[String],position:Vector2,remove:Control=null):
	visible = true
	self.position = position
	for child in $MarginContainer/VBoxContainer.get_children():
		child.queue_free()
	if is_instance_valid(remove):
		if !remove.mouse_exited.is_connected(remove_label):
			remove.mouse_exited.connect(remove_label)
	
	for t in text:
		var rich_text = RichTextLabel.new()
		rich_text.bbcode_enabled = true
		rich_text.fit_content = true
		rich_text.autowrap_mode = TextServer.AUTOWRAP_OFF
		rich_text.append_text(t)
		$MarginContainer/VBoxContainer.add_child(rich_text)

func remove_label():
	visible = false
