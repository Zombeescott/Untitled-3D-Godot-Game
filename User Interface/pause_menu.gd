extends Control


@export var settings : Control


func _on_resume_pressed() -> void:
	Global.unpause_scene()


func _on_settings_pressed() -> void:
	Global.settings_scene()


func _on_exit_game_pressed() -> void:
	get_tree().quit()
