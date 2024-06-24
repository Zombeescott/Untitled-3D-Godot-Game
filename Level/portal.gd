extends Node3D


# Hard-coded path in case the packed scene export doesn't work for some inexplicable reason
@export var warp_location_path : String
# Load test map by default
@export var warp_location : PackedScene = load("res://Level/test_map.tscn")


func _ready() -> void:
	if warp_location_path:
		warp_location = load(warp_location_path)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("Portalling")
		# In case the level script is empty
		Global.end_level()
		call_deferred("change_scene")


func change_scene() -> void:
	if warp_location:
		get_tree().change_scene_to_packed(warp_location)
