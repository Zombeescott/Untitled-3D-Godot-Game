extends Node


var coin_count = 0
var crystal_count = 0
var curr_level : Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_curr_scene(scene: Node3D) -> void:
	curr_level = scene


func item_collected(item: ItemBase) -> void:
	match item.item_type:
		"coin":
			coin_count += 1
		"crystal":
			crystal_count += 1
