class_name Player
extends KinematicBody2D

signal meter_updated(meter_amount)

const SWING_WIDTH : float = 200.0
const SWING_SPEED : float = 0.25
const SPARKS_TEMPLATE : Resource = preload("res://sparks/sparks.tscn")

onready var anim_player : AnimationPlayer = $AnimationPlayer as AnimationPlayer

var miss_sound : AudioStreamSample = load("res://sounds/sfx/just_a_swish.wav") as AudioStreamSample
var weak_hit_sound : AudioStreamSample = load("res://sounds/sfx/laser_attack_mini.wav") as AudioStreamSample
var medium_hit_sound : AudioStreamSample = load("res://sounds/sfx/extra_hit_point.wav") as AudioStreamSample
var strong_hit_sound : AudioStreamSample = load("res://sounds/sfx/direct_attack.wav") as AudioStreamSample

var player_class

var balls_in_range : Array = []
var special_meter : int = 0
var can_move : bool = true


func _ready():
	_load_player_class()
	
	$SwingArea.connect("body_entered", self, "_on_SwingArea_body_entered")
	$SwingArea.connect("body_exited", self, "_on_SwingArea_body_exited")
	
	$Saber.set_rotation_degrees(- SWING_WIDTH / 2)
	$SwingArea.modulate = Color(1,1,1,0)
	pass


func _process(_delta : float) -> void:
	if anim_player.current_animation == "":
		if Input.is_action_just_pressed(_get_input_name("special")):
			if special_meter >= player_class.max_special_meter:
				cast_special()
				special_meter = 0
				emit_signal("meter_updated", special_meter)
			elif !$FailSpecialSound.is_playing():
				$FailSpecialSound.play()
		
		for swing_type in Ball.BALL_SPEEDS:
			if swing_type == "special":
				continue
			if Input.is_action_just_pressed(_get_input_name(swing_type)):
				swing()
				deflect_balls(Ball.BALL_SPEEDS.get(swing_type))
				break
	pass	

			
func _physics_process(delta : float) -> void:
	if can_move:
		var direction : int = 0
		
		if Input.is_action_pressed(_get_input_name("down")):
			direction += 1
		if Input.is_action_pressed(_get_input_name("up")):
			direction -= 1

		move_and_collide(Vector2.DOWN * delta * player_class.get_move_speed() * direction)
	pass


func _get_input_name(base_name : String) -> String:
	return "p" + str(get_index() + 1) + "_" + base_name
	

func swing() -> void:
	anim_player.play("Swing")
	set_scale(get_scale() * Vector2(1, -1))


func deflect_balls(hit_speed : int) -> bool:
	if balls_in_range.empty():
		$HitSound.stream = miss_sound
		$HitSound.play()
		return false
		
	_play_hit_sound(hit_speed)
	
	for ball in balls_in_range:		
		var new_sparks : Particles2D = SPARKS_TEMPLATE.instance() as Particles2D
		new_sparks.material = material
		get_tree().root.get_node("Level").add_child(new_sparks)
		new_sparks.position = ball.position
		new_sparks.emitting = true
		
		var deflection_angle : Vector2 = get_position().direction_to(ball.get_position())
		deflection_angle.y /= 2

		_calc_meter_bonus(hit_speed, ball.get_speed())
			
		ball.hit_ball(deflection_angle.normalized(), hit_speed)
	
	return true


func _play_hit_sound(hit_speed : int) -> void:
	if hit_speed >= Ball.BALL_SPEEDS.get("strong"):
		$HitSound.stream = strong_hit_sound
	elif hit_speed >= Ball.BALL_SPEEDS.get("medium"):
		$HitSound.stream = medium_hit_sound
	else:
		$HitSound.stream = weak_hit_sound
		
	$HitSound.play()
	

func _calc_meter_bonus(hit_speed : int, ball_speed : int) -> void:
	if ball_speed >= Ball.BALL_SPEEDS.get("strong"):
		_add_to_special_meter(15)
	elif ball_speed >= Ball.BALL_SPEEDS.get("medium"):
		_add_to_special_meter(10)
	elif ball_speed >= Ball.BALL_SPEEDS.get("weak"):
		_add_to_special_meter(5)
		
	if hit_speed >= Ball.BALL_SPEEDS.get("strong"):
		_add_to_special_meter(15)
	elif hit_speed >= Ball.BALL_SPEEDS.get("medium"):
		_add_to_special_meter(10)
	else:
		_add_to_special_meter(5)
	
		

func _add_to_special_meter(amount : int) -> void:
	if special_meter == player_class.max_special_meter:
		return
		
	special_meter = min(special_meter + amount, player_class.max_special_meter)
	if special_meter == player_class.max_special_meter:
		$MeterFilledSound.play()
	emit_signal("meter_updated", special_meter)
	

func _on_SwingArea_body_entered(body : PhysicsBody2D) -> void:
	if body != self:
		balls_in_range.append(body)


func _on_SwingArea_body_exited(body : PhysicsBody2D) -> void:
	balls_in_range.erase(body)


func cast_special() -> void:
	$CastSpecialSound.play()
	$Special.cast_special()
	pass


func slow_time() -> void:
	Engine.time_scale /= 10
	anim_player.playback_speed *= 10
	$CastingEffect.speed_scale *= 10
	
	
func speed_time() -> void:
	Engine.time_scale *= 10
	anim_player.playback_speed /= 10
	$CastingEffect.speed_scale /= 10
	
	
func _load_player_class() -> void:
	set_material(player_class.material)
	
	$Saber.set_scale(Vector2.ONE * player_class.get_saber_size())
	$SwingArea.set_scale(Vector2.ONE * player_class.get_saber_size())
	
	$Special.set_script(player_class.special_script)
