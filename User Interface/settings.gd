extends Control


@export var sens_slider : HSlider
@export var speed_box : CheckBox

var saved_sens
var saved_speed


func _ready() -> void:
	saved_sens = sens_slider.value
	saved_speed = speed_box.button_pressed


func _on_save_button_pressed() -> void:
	if sens_slider.value != 0:
		saved_sens = sens_slider.value
	else:
		saved_sens = .001
	saved_speed = speed_box.button_pressed
	
	Global.stop_settings_scene()
