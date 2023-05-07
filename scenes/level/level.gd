extends Node

signal score_changed(player_changed, new_score)

const PLAYER_TEMPLATE : Resource = preload("res://player/player.tscn")
const BALL_TEMPLATE : Resource = preload("res://ball/ball.tscn")

onready var p1_end_zone : Area2D = $Map/ScoreZones/P1EndZone
onready var p2_end_zone : Area2D = $Map/ScoreZones/P2EndZone

var player_1 : Player
var player_2 : Player
var ball : Ball

var _p1_score : int = 0
var _p2_score : int = 0


func change_score(player : Player, new_score : int) -> void:
	if player == player_1 and _p1_score != new_score:
		_p1_score = new_score
		emit_signal("score_changed", 1, new_score)
	elif player == player_2 and _p2_score != new_score:
		_p2_score = new_score
		emit_signal("score_changed", 2, new_score)


func get_score(player : Player) -> int:
	if player == player_1:
		return _p1_score
	else:
		return _p2_score


func _ready() -> void:
	p1_end_zone.connect("body_entered", self, "_on_player_scored", [p1_end_zone])
	p2_end_zone.connect("body_entered", self, "_on_player_scored", [p2_end_zone])
	
	_setup_new_game()


func _setup_new_game() -> void:
	if player_1:
		player_1.queue_free()
	if player_2:
		player_2.queue_free()
		
	$Interface.set_max_meter(1)
	$Interface.set_max_meter(2)
	
	player_1 = _create_player(Global.get_player_class(1))
	player_2 = _create_player(Global.get_player_class(2))

	player_1.position = Vector2(100, 1080 / 2)
	player_2.position = Vector2(1920 - 100, 1080 / 2)
	
	player_2.rotation = PI
	
	change_score(player_1, 0)
	change_score(player_2, 0)
	
	player_1.connect("meter_updated", $Interface, "update_meter", [1])
	player_2.connect("meter_updated", $Interface, "update_meter", [2])
	
	_reset_round(player_1)
	
	pass
	

func _create_player(player_class) -> Player:
	var new_player : Player = PLAYER_TEMPLATE.instance() as Player
	new_player.player_class = player_class
	$Players.add_child(new_player)
	
	return new_player
	

func _on_player_scored(_body : PhysicsBody2D, zone_scored : Area2D) -> void:
	$ScoreSound.play()
	
	for old_ball in get_tree().get_nodes_in_group("Ball"):
		old_ball.despawn()
	
	if zone_scored == p2_end_zone:
		change_score(player_1, get_score(player_1) + 1)
		$Interface.make_announcement("Player 1 Scored!")
	else:
		change_score(player_2, get_score(player_2) + 1)
		$Interface.make_announcement("Player 2 Scored!")
	
	yield($Interface, "announcement_finished")
	
	if _check_for_winner():
		yield($Interface, "announcement_finished")
		Global.back_to_title_screen()
	else:
		if zone_scored == p2_end_zone:
			_reset_round(player_2)
		else:
			_reset_round(player_1)


func _check_for_winner() -> bool:
	if _p1_score >= 7:
		$Interface.make_announcement("Player 1 Wins!")
	elif _p2_score >= 7:
		$Interface.make_announcement("Player 2 Wins!")
	else:
		return false
	return true
	

func _reset_round(player_with_ball : Player) -> void:
	ball = BALL_TEMPLATE.instance() as Ball
	add_child(ball)
	
	if player_with_ball == player_1:
		ball.position = Vector2(150, 1080 / 2)
	else:
		ball.position = Vector2(1920 - 150, 1080 / 2)
		
	$BallPlacedSound.play()
	ball.get_node("Explosion").emitting = true
	pass
