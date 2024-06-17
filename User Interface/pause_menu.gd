extends Control


func _on_resume_pressed() -> void:
	self.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#Global.user.grab_focus


func _on_settings_pressed() -> void:
	pass # Replace with function body.


func _on_exit_game_pressed() -> void:
	get_tree().quit()
