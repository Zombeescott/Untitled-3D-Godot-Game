extends StaticBody3D


@onready var sign : CanvasLayer = $CanvasLayer

@export var text : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if text:
		$CanvasLayer/ColorRect/Label.text = text


func interact() -> void:
	if !sign.visible:
		sign.visible = true
	else:
		sign.visible = false


func _on_read_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.interact_signal(self)


func _on_read_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.interact_signal(self)
		sign.visible = false
