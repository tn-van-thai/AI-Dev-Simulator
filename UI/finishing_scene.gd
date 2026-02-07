extends CanvasLayer

func play(ethics_scale):
	visible = true

	var type
	if (ethics_scale >= 50):
		if (ethics_scale < 170): type = 2
		else: type = 3
	else:
		if (ethics_scale < -45): type = 0
		else: type = 1
	
	await get_tree().create_timer(2).timeout
	await $Ethics.start_text(ethics_scale)

	await get_tree().create_timer(3).timeout
	$EthicsMessage.start_text(type)

	await get_tree().create_timer(2).timeout
	await $Endings.start_text(type)
