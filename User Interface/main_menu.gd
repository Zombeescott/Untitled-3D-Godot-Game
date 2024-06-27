extends Control


@onready var hub : PackedScene = Global.hub_world


func _ready() -> void:
	Global.main_menu = self


func start_main_menu() -> void:
	get_tree().change_scene(self)
	$CanvasLayer.visible = true
	Global.unpause_scene()


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_packed(hub)
	$CanvasLayer.visible = false


func _on_load_game_pressed() -> void:
	print("Sorry bro, this does nothing atm")


func _on_exit_game_pressed() -> void:
	get_tree().quit()
