extends Special

var sound_effect : AudioStreamSample = load("res://sounds/sfx/crystal_destroy.wav") as AudioStreamSample

func _init() -> void:
	._init()
	$SpecialSound.stream = sound_effect

func cast_special() -> void:
	anim_player.play("Freeze")
	pass


func freeze() -> void:
	for ball in get_tree().get_nodes_in_group("Ball"):
		ball.add_modifier(self, 0.2)
		
	$SpecialSound.play()
		
	yield(get_tree().create_timer(5), "timeout")
	
	for ball in get_tree().get_nodes_in_group("Ball"):
		ball.remove_modifier(self)
	pass

