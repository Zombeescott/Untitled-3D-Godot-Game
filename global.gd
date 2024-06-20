extends Node


var coin_count = 0
var crystal_count = 0
var player : Node3D
var curr_level : Node3D

@onready var interface : Control = $"User Interface"
@onready var pause : Control = $"Pause Menu"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause.get_child(0).hide()
	interface.grab_focus
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func set_curr_scene(scene: Node3D, player: Node3D) -> void:
	curr_level = scene
	self.player = player


func update_health(health : HealthComponent) -> void:
	interface.update_health(health)


func item_collected(item: ItemBase) -> void:
	match item.item_type:
		"coin":
			coin_count += 1
		"crystal":
			crystal_count += 1
	interface.update_ui()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		if pause.get_child(0).visible == false:
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
	pause.get_child(0).hide()
	interface.grab_focus
	if curr_level:
		self._set_processing(curr_level, true)


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
