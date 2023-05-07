extends Special

const GROW_SCALE : float = 1.5

var swing_area : Node2D
var saber : Node2D
var orig_scale : Vector2

var total_scale : Vector2


func _init():
	._init()
	swing_area = get_node("../SwingArea") as Node2D
	saber = get_node("../Saber") as Node2D
	
	pass


func cast_special() -> void:
	orig_scale = saber.get_scale()
	total_scale = orig_scale
	
	anim_player.play("Giga Saber")
	
	yield(get_tree().create_timer(7), "timeout")
	revert_saber()
	pass


func grow_saber() -> void:
	var tween : SceneTreeTween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	total_scale *= 1.5
	tween.tween_property(swing_area, "scale", total_scale, 0.2 * Engine.time_scale)
	tween.tween_property(saber, "scale", total_scale, 0.2 * Engine.time_scale)
	
	

func revert_saber() -> void:
	var tween : SceneTreeTween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(swing_area, "scale", orig_scale, 0.5)
	tween.tween_property(saber, "scale", orig_scale, 0.5)
	
