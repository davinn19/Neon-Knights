class_name Submenu
extends Control


func _ready() -> void:
	rect_position = Vector2(0, 1100)
	yield(self, "ready")
	disable_input()
	reset()
	pass
	

func reset() -> void:
	pass


func disable_input() -> void:
	$InputCover.anchor_right = 1
	
	
func enable_input() -> void:
	$InputCover.anchor_right = 0
