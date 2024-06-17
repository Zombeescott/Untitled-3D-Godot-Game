extends Node3D


var num_coins : int = 9
var coins_collected : int = 0
@export var num_crystals : int = 4
var found_crystals : Array[bool]
@export var num_barrels : int = 6
var broken_barrels : int = 0

# Found in the middle in the air
@export var crystal_0 : Node3D
# Collect all the coins
@export var crystal_1 : Node3D
# Break all the barrels
@export var crystal_2 : Node3D
# Collect all green coins
@export var crystal_3 : Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.set_curr_scene(self, %Player)
	%Player.item_collected() # Update UI
	# load from save file in future
	found_crystals = [false, false, false, false, false, false]
	# Crystals will be invisible by default in the future
	crystal_1.hide_item()
	crystal_2.hide_item()
	crystal_3.hide_item()


func item_collected(item: ItemBase) -> void:
	match item.item_type:
		"crystal":
			if !found_crystals[item.id]:
				found_crystals[item.id] = true
				print("Crystal ", item.id, " found!")
		"coin":
			coins_collected += 1
			if coins_collected >= num_coins:
				crystal_1.crystal_appear()
		
	Global.item_collected(item)


func interaction_occured(event : String) -> void:
	match event:
		"barrel":
			broken_barrels += 1
			if num_barrels <= broken_barrels:
				# TODO make appear at the last barrel broke?
				crystal_2.crystal_appear()
		"green":
			if !found_crystals[3]:
				crystal_3.crystal_appear()
	


