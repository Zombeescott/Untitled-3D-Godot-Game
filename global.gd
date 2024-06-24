extends Node


var total_coins = 0
var coin_count = 0
var total_crystals = 0
var crystal_count = 0
var player : Node3D
var curr_level : Node3D

@export var interface : Control
@export var pause : Control
@export var settings : Control
@export var hub_world : PackedScene = load("res://Level/test_map.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause.get_child(0).hide()
	settings.get_child(0).hide()
	interface.grab_focus
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func set_curr_scene(scene: Node3D, player: Node3D) -> void:
	curr_level = scene
	self.player = player
	interface.update_ui()


func item_collected(item: ItemBase) -> void:
	# Increment total coins away from levels to store total collected (for now?)
	match item.item_type:
		"coin":
			total_coins += 1
			coin_count += 1
		"crystal":
			crystal_count += 1
			total_crystals += 1
	interface.update_ui()


func update_health(health : HealthComponent) -> void:
	interface.update_health(health)
	
	if health.health <= 0:
		# Send player back to hub world
		#call_deferred("end_level")
		get_tree().change_scene_to_packed(hub_world)


func update_timer(time : float) -> void:
	interface.update_timer(time)


func timer_remove() -> void:
	interface.timer_remove()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		if pause.get_child(0).visible == false and settings.get_child(0).visible == false:
			pause_scene()
		else:
			unpause_scene()


func pause_scene() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pause.get_child(0).show()
	pause.grab_focus
	if curr_level:
		self._set_processing(curr_level, false)


func unpause_scene() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	stop_settings_scene() # just in case
	pause.get_child(0).hide()
	interface.grab_focus
	if curr_level:
		self._set_processing(curr_level, true)


func settings_scene() -> void:
	pause.get_child(0).hide()
	settings.get_child(0).show()
	settings.grab_focus


func stop_settings_scene() -> void:
	settings.get_child(0).hide()
	pause.get_child(0).show()
	pause.grab_focus


# Halts a node and all their children (Could be optimitzed)
func _set_processing(node, enabled):
	if node.get_groups().has("entity"):
		node.set_process(enabled)
		node.set_physics_process(enabled)
		node.set_process_input(enabled)
		#node.set_process_unhandled_input(enabled)
		#node.set_process_unhandled_key_input(enabled)
	#if node is AnimationPlayer and node.is_playing():
	#	if enabled:
	#		node.play()
	#	else:
	#		node.pause()
	if node is Timer:
		node.paused = !enabled
	for child in node.get_children():
		_set_processing(child, enabled)


func pause_entities() -> void:
	for i in get_tree().get_nodes_in_group("entity"):
		i.set_process(false)
		i.set_physics_process(false)


func unpause_entities() -> void:
	for i in get_tree().get_nodes_in_group("entity"):
		i.set_process(true)
		i.set_physics_process(true)


func end_level() -> void:
	coin_count = 0
	crystal_count = 0
	curr_level = null
	interface.timer_remove()
