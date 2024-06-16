extends Node3D


var num_coins : int = 9
var coins_collected : int = 0
@export var num_crystals : int = 6
var found_crystals : Array[bool]
@export var num_barrels : int = 6
var broken_barrels : int = 0

# Found in the middle in the air
@export var crystal_0 : Node3D
# Collect all the coins
@export var crystal_1 : Node3D
# Break all the barrels
@export var crystal_2 : Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.set_curr_scene(self)
	# load from save file in future
	found_crystals = [false, false, false, false, false, false]
	# Crystals will be invisible by default in the future
	set_item_invisible(crystal_1)
	set_item_invisible(crystal_2)


func set_item_invisible(item: Node3D) -> void:
	item.get_child(0).monitoring = false
	item.get_child(0).monitorable = false
	item.visible = false


func set_item_visible(item: Node3D) -> void:
	item.get_child(0).monitoring = true
	#item.get_child(0).monitorable = true
	item.visible = true


func item_collected(item_type: String, id: int) -> void:
	match item_type:
		"crystal":
			if !found_crystals[id]:
				found_crystals[id] = true
				print("Crystal ", id, " found!")
		"coin":
			coins_collected += 1
			if coins_collected >= num_coins:
				set_item_visible(crystal_1)
		
	Global.item_collected(item_type)


func interaction_occured(event : String) -> void:
	match event:
		"barrel":
			broken_barrels += 1
			if num_barrels <= broken_barrels:
				# TODO make appear at the last barrel broke?
				set_item_visible(crystal_2)
	