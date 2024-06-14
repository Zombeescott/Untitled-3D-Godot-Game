extends Node3D


var num_coins : int = 1
var coins_collected : int = 10

@export var num_crystals : int = 6
var found_crystals : Array[bool]

@export var crystal_0 : Node3D
@export var crystal_1 : Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.set_curr_scene(self)
	# load from save file in future
	found_crystals = [false, false, false, false, false, false]
	# Crystals will be invisible by default in the future
	set_item_invisible(crystal_1)


func set_item_invisible(item: Node3D) -> void:
	item.get_child(0).monitoring = false
	item.get_child(0).monitorable = false
	item.visible = false


func set_item_visible(item: Node3D) -> void:
	item.get_child(0).monitoring = true
	#item.get_child(0).monitorable = true
	item.visible = true


func item_collected(item_type: String, id: int) -> void:
	if item_type == "crystal":
		if !found_crystals[id]:
			found_crystals[id] = true
			print("Crystal ", id, " found!")
	elif item_type == "coin":
		coins_collected += 1
		if coins_collected >= num_coins:
			set_item_visible(crystal_1)
		
	Global.item_collected(item_type)
