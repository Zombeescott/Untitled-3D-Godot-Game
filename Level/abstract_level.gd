extends Node3D
class_name LevelBase


@export var num_coins : int = 9
var coins_collected : int = 0
@export var num_crystals : int = 5
var found_crystals : Array[bool]
@export var num_barrels : int = 6
var broken_barrels : int = 0

var speedrunning : bool = false
var elapsed_time : float = 0

# Pre-spawned crystal
@export var reach_crystal : Node3D
# Collect all the coins
@export var coin_crystal : Node3D
# Break all the barrels / destructables
@export var destroy_crystal : Node3D
# Collect all green coins
@export var green_crystal : Node3D
# Finish race
@export var race_crystal : Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.set_curr_scene(self, %Player)
	Global.interface.update_ui() # Update UI
	if Global.get_settings().saved_speed:
		speedrunning = true
	# load from save file in future
	found_crystals = [false, false, false, false, false, false]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# speedrunning is turned false in global's item_collected function when all crystals are collected
	if speedrunning:
		elapsed_time += delta
		Global.update_speedrun_timer(round(elapsed_time * 100) / 100.0)


func item_collected(item: ItemBase) -> void:
	match item.item_type:
		"crystal":
			if !found_crystals[item.id]:
				found_crystals[item.id] = true
				print("Crystal ", item.id, " found!")
		"coin":
			coins_collected += 1
			if coins_collected >= num_coins:
				coin_crystal.crystal_appear()
	
	Global.item_collected(item)


func interaction_occured(event : String) -> void:
	match event:
		"barrel":
			broken_barrels += 1
			if num_barrels <= broken_barrels:
				destroy_crystal.crystal_appear()
		"green":
			if !found_crystals[3]:
				green_crystal.crystal_appear()
		"race":
			if !found_crystals[4]:
				race_crystal.crystal_appear()
