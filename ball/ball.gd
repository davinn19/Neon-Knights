class_name Ball
extends KinematicBody2D

signal ball_hit()

const BALL_SPEEDS : Dictionary = {"special" : 0, "weak" : 700, "medium" : 900, "strong" : 1100}


var direction : Vector2 = Vector2.ZERO
var _speed : int = 0
var _speed_modifiers : Dictionary = {}


func get_speed() -> float:
	var final_speed : float = _speed
	for modifier in _speed_modifiers.values():
		final_speed *= modifier
	
	return final_speed


func add_modifier(source : Node, modifier : float) -> void:
	_speed_modifiers[source] = modifier
	pass


func remove_modifier(source : Node) -> void:
	_speed_modifiers.erase(source)
	pass


func set_speed(speed : int) -> void:
	_speed = speed
	pass


func _physics_process(delta : float) -> void:
	var collision : KinematicCollision2D = move_and_collide(direction * get_speed() * delta)

	if collision and collision.collider is StaticBody2D:
		direction = direction.reflect(Vector2.UP.rotated(collision.collider.get_rotation()))
		$BounceExplosion.emitting = true


func hit_ball(direction : Vector2, ball_speed : int) -> void:
	emit_signal("ball_hit")
	self.direction = direction
	set_speed(ball_speed)
	$Explosion.emitting = true
	_speed_modifiers.clear()


func despawn() -> void:
	$Trail.emitting = false
	$Body.visible = false
	$Hitbox.set_deferred("disabled", true)
	_speed = 0

	yield(get_tree().create_timer($Trail.lifetime), "timeout")
	queue_free()
	pass
