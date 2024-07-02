extends Control


@export var sens_slider : HSlider
@export var speed_box : CheckBox
@export var speedometer_box : CheckBox

var saved_sens
var saved_speed
var saved_meter


func _ready() -> void:
	saved_sens = sens_slider.value
	saved_speed = speed_box.button_pressed
	saved_meter = speedometer_box.button_pressed


func _on_save_button_pressed() -> void:
	if sens_slider.value != 0:
		saved_sens = sens_slider.value
	else:
		saved_sens = .001
	saved_speed = speed_box.button_pressed
	saved_meter = speedometer_box.button_pressed
	if Global.player:
		Global.player.settings_changed(self)
	
	Global.stop_settings_scene()
