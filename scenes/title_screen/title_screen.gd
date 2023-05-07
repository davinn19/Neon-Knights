extends Node

const BALL_TEMPLATE : Resource = preload("res://ball/ball.tscn")
const BALL_PLACEMENT_PADDING : int = 50


func _ready() -> void:
	for _i in range(5):
		_add_ball(_get_random_pos_on_screen())
	

func _get_random_pos_on_screen() -> Vector2:
	var viewport_size : Vector2 = get_viewport().get_visible_rect().size
	var x : int = randi() % int(viewport_size.x - BALL_PLACEMENT_PADDING * 2) + BALL_PLACEMENT_PADDING
	var y : int = randi() % int(viewport_size.y - BALL_PLACEMENT_PADDING * 2) + BALL_PLACEMENT_PADDING
	
	return  Vector2(x, y) 
	

func _add_ball(position : Vector2) -> void:
	var new_ball : Ball = BALL_TEMPLATE.instance() as Ball
	$Balls.add_child(new_ball)
	new_ball.set_position(position)
	new_ball.direction = Vector2.RIGHT.rotated(rand_range(0, 360))
	new_ball.set_speed(rand_range(250, 750))
	
