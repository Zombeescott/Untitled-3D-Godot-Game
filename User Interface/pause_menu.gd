extends Control


@export var settings : Control


func _on_resume_pressed() -> void:
	Global.unpause_scene(true)


func _on_settings_pressed() -> void:
	Global.settings_scene()


func _on_exit_to_menu_pressed() -> void:
	Global.main_menu_scene()


func _on_exit_game_pressed() -> void:
	get_tree().quit()
