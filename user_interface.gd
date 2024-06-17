extends Control


func update_ui() -> void:
	if Global.curr_level:
		$"CanvasLayer/Coin Count".text = "Coins: " + str(Global.coin_count, "/", Global.curr_level.num_coins)
		$"CanvasLayer/Crystal Count".text = str("Crystals: ", Global.crystal_count, "/", Global.curr_level.num_crystals)
	else:
		$"CanvasLayer/Coin Count".text = "Coins: " + str(Global.coin_count)
		$"CanvasLayer/Crystal Count".text = str("Crystals: ", Global.crystal_count)
	
