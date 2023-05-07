extends Control

signal announcement_finished()

onready var scoreboard : Control = $VBoxContainer/TopBar/Scoreboard
onready var announcer : Label = $VBoxContainer/Announcement



func _ready() -> void:
	get_parent().connect("score_changed", self, "update_scoreboard")
	announcer.visible = false
	pass


func update_scoreboard(player_changed : int, new_score : int) -> void:
	scoreboard.get_node("Player" + str(player_changed)).text = str(new_score)
	pass


func make_announcement(announcement : String) -> void:
	announcer.text = announcement
	announcer.visible = true
	yield(get_tree().create_timer(3), "timeout")
	
	announcer.visible = false
	emit_signal("announcement_finished")


func set_max_meter(player_num : int) -> void:
	var player_class : PlayerClass = Global.get_player_class(player_num)
	var max_meter : int = player_class.max_special_meter
	_get_meter(player_num).max_value = max_meter
	_get_meter(player_num).modulate = player_class.color


func update_meter(new_val : int, player_changed : int) -> void:
	var tween : SceneTreeTween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(_get_meter(player_changed), "value", new_val * 1.0, 0.2)


func _get_meter(player_num : int) -> TextureProgress:
	return $VBoxContainer/TopBar.get_node("Player" + str(player_num)) as TextureProgress
	

