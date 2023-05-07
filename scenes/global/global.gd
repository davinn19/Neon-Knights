extends Node

var level : PackedScene = load("res://scenes/level/level.tscn") as PackedScene
var title_screen : PackedScene = load("res://scenes/title_screen/title_screen.tscn") as PackedScene

var classes : Array = []
export var bgm : Array = []

var selected_classes : Array = []

var next_scene : PackedScene = title_screen

func _init():
	_load_classes()
	randomize()

	selected_classes.append(classes[0])
	selected_classes.append(classes[0])
	pass
	

func _ready():
	_play_new_bgm()


func get_player_class(player_num : int) -> PlayerClass:
	return selected_classes[player_num - 1]


func start_game() -> void:
	next_scene = level
	$AnimationPlayer.play("Transition")
	$SwitchSceneSound.play()
	pass
	

func back_to_title_screen() -> void:
	next_scene = title_screen
	$AnimationPlayer.play("Transition")
	$SwitchSceneSound.play()
	pass

func _switch_scene() -> void:
	get_tree().change_scene_to(next_scene)


func _on_BGM_finished() -> void:
	yield(get_tree().create_timer(3), "timeout")
	_play_new_bgm()
	
	
func _play_new_bgm() -> void:
	while true:
		var song_chosen : AudioStreamSample = bgm[randi() % bgm.size()]
		if song_chosen != $BGM.stream:
			$BGM.stream = song_chosen
			break
	$BGM.play()
	
	

func _load_classes() -> void:
	var dir = Directory.new()
	var path : String = "res://player_classes/"
	dir.open(path)
	dir.list_dir_begin(true)

	while true:
		var file = dir.get_next()
		if file == "":
			break
		classes.append(load(path + file))

	dir.list_dir_end()
