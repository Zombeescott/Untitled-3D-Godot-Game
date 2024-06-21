extends Control


@export var sens_slider : HSlider
@export var wall_box : CheckBox


func _on_save_button_pressed() -> void:
	if sens_slider.value != 0:
		Global.player.sens = sens_slider.value
	else:
		Global.player.sens = .001
		
	#Global.player.wall_hang_active = wall_box.button_pressed
	Global.stop_settings_scene()
