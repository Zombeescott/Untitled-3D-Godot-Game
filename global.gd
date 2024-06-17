extends Node


var coin_count = 0
var crystal_count = 0
var player : Node3D
var curr_level : Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_curr_scene(scene: Node3D, player: Node3D) -> void:
	curr_level = scene
	self.player = player


func item_collected(item: ItemBase) -> void:
	match item.item_type:
		"coin":
			coin_count += 1
		"crystal":
			crystal_count += 1


func pause_entities() -> void:
	for i in get_tree().get_nodes_in_group("entity"):
		i.set_process(false)
		i.set_physics_process(false)


func unpause_entities() -> void:
	for i in get_tree().get_nodes_in_group("entity"):
		i.set_process(true)
		i.set_physics_process(true)
