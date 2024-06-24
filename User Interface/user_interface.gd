extends Control


@export var health_container : ColorRect
@onready var heart = load("res://Textures/Shadow.png")
@onready var empty_heart = load("res://Textures/Tile_07-128x128.png")

@onready var timer_label = $CanvasLayer/Timer


func update_ui() -> void:
	if Global.curr_level:
		$"CanvasLayer/Coin Count".text = "Coins: " + str(Global.coin_count, "/", Global.curr_level.num_coins)
		$"CanvasLayer/Crystal Count".text = str("Crystals: ", Global.crystal_count, "/", Global.curr_level.num_crystals)
		var health = Global.player.get_node("Health component")
		call_deferred("update_health", health)
	else:
		$"CanvasLayer/Coin Count".text = "Coins: " + str(Global.coin_count)
		$"CanvasLayer/Crystal Count".text = str("Crystals: ", Global.crystal_count)
	

func update_health(health : HealthComponent) -> void:
	for i in health_container.get_child_count():
		if i < health.health:
			health_container.get_child(i).texture = heart
		else:
			health_container.get_child(i).texture = empty_heart


func update_timer(time : float) -> void:
	if timer_label.visible == false:
		timer_label.visible = true
	# TODO If whole #, it just says 2 instead 2.00 and I don wanna fix it rn
	timer_label.text = str(time)


func set_timer_color(color : String) -> void:
	match color:
		"white": 
			timer_label.add_theme_color_override("font_color", Color(1, 1, 1))
		"red": 
			timer_label.add_theme_color_override("font_color", Color(1, 0, 0))
		"green": 
			timer_label.add_theme_color_override("font_color", Color(0, 1, 0))
		"blue": 
			timer_label.add_theme_color_override("font_color", Color(0, 0, 1))


func timer_remove() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	$CanvasLayer/Timer.visible = false
	set_timer_color("white")
