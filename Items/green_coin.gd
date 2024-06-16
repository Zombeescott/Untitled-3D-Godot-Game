extends ItemBase


@export var button: Node3D
@export var label: Label3D
@export var timer: Timer


func _ready() -> void:
	# This script is very fussy with duplicating and it's easier if this is this
	area = self.get_child(0)


func _on_area_3d_body_entered(body: Node3D) -> void:
	#body_entered(body)
	self.hide_item()
	# just to make the label appear
	self.visible = true
	timer.start()
	
	button.coins_collected += 1
	label.text = str(button.coins_collected, "/", button.num_coins)
	
	# Tells level all to release crystal when all are collected
	if button.coins_collected >= button.num_coins:
		Global.curr_level.interaction_occured(item_type)


func _on_timer_timeout() -> void:
	label.text = ""
