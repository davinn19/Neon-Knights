class_name Special
extends Node

var anim_player : AnimationPlayer


func _init() -> void:
	anim_player = get_node("../AnimationPlayer") as AnimationPlayer
	

func cast_special() -> void:
	pass
