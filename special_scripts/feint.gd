extends Special

var sound_effect : AudioStreamSample = load("res://sounds/sfx/missile_launch_mini_2.wav") as AudioStreamSample
var BALL_TEMPLATE : Resource = load("res://ball/ball.tscn")

func _init() -> void:
	._init()
	$SpecialSound.stream = sound_effect

func cast_special() -> void:
	anim_player.play("Feint")
	pass


func shoot_ball() -> void:
	var fake_ball : Ball = BALL_TEMPLATE.instance() as Ball
	get_tree().root.get_node("Level").add_child(fake_ball)
	
	var angle : float = get_parent().rotation + rand_range(-PI / 4, PI / 4)
	fake_ball.direction = Vector2.RIGHT.rotated(angle)
	fake_ball.position = get_parent().position + Vector2.RIGHT.rotated(get_parent().rotation) * 150
	fake_ball.set_speed(500)
	fake_ball.connect("ball_hit", fake_ball, "despawn")
	
	$SpecialSound.play()
	pass
