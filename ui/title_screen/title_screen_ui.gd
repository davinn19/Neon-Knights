extends Control

onready var character_select : Submenu = $Submenus/CharacterSelect as Submenu
onready var controls : Submenu = $Submenus/Controls as Submenu
onready var credits : Submenu = $Submenus/Credits as Submenu
onready var tutorial : Submenu = $Submenus/Tutorial as Submenu

var _cur_sub_menu : Submenu


func _on_Play_pressed() -> void:
	_transition_to_submenu(character_select)
	pass


func _on_Tutorial_pressed():
	_transition_to_submenu(tutorial)
	pass
	

func _on_Controls_pressed() -> void:
	_transition_to_submenu(controls)
	pass
	

func _on_Credits_pressed() -> void:
	_transition_to_submenu(credits)
	pass


func _on_Exit_pressed() -> void:
	get_tree().quit()


func _transition_to_submenu(submenu : Submenu) -> void:
	if !$Tween.is_active():
		$Tween.remove_all()
		$SubmenuSwitchSound.play()
		
		if _cur_sub_menu:
			_cur_sub_menu.disable_input()
			$Tween.interpolate_property(_cur_sub_menu, "rect_position", Vector2.ZERO, Vector2(0, 1100), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		if _cur_sub_menu != submenu:
			submenu.enable_input()
			$Tween.interpolate_property(submenu, "rect_position", Vector2(0, 1100), Vector2.ZERO, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			_cur_sub_menu = submenu
		else:
			_cur_sub_menu = null
		
		$Tween.start()
