extends Special

var sound_effect : AudioStreamSample = load("res://sounds/sfx/fire_burn_out.wav") as AudioStreamSample

	
func _init() -> void:
	._init()
	$SpecialSound.stream = sound_effect
	
	
func cast_special() -> void:
	anim_player.play("Power Swing")
	pass


func strike() -> void:
	var hit_something : bool = get_parent().deflect_balls(2500)
	if hit_something:
		
		$SpecialSound.play()
	pass
