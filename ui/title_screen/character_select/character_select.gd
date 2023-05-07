extends Submenu

const CHARACTER_BUTTON_TEMPLATE : Resource = preload("res://ui/title_screen/character_select/character_button.tscn")

onready var character_select_modules : Array = $VBoxContainer/HSplitContainer.get_children()


func _ready() -> void:
	._ready()
	$VBoxContainer/Start.connect("pressed", Global, "start_game")
	_create_character_buttons()
	pass
	

func reset() -> void:
	for player_index in range(2):
		var player_class : PlayerClass = Global.get_player_class(player_index + 1)
		var module : Control = character_select_modules[player_index] as Control
		
		module.get_node("PlayerName").text = player_class.name
		module.get_node("Stats/SaberSize").text = "Reach: " + player_class.get_saber_size_string()
		module.get_node("Stats/MoveSpeed").text = "Speed: " + player_class.get_move_speed_string()
		module.get_node("SpecialDescription").text = player_class.special_description
	

	
func _create_character_buttons() -> void:
	for class_index in range(Global.classes.size()):
		var player_class = Global.classes[class_index]
		
		var normal_style : StyleBoxFlat = StyleBoxFlat.new()
		normal_style.bg_color = player_class.color
		
		var hover_style : StyleBoxFlat = StyleBoxFlat.new()
		hover_style.bg_color = player_class.color.lightened(0.2)
		
		var pressed_style : StyleBoxFlat = StyleBoxFlat.new()
		pressed_style.bg_color = player_class.color.darkened(0.3)
		
		for player_index in character_select_modules.size():
			var module : Control = character_select_modules[player_index] as Control
			var new_button : Button = CHARACTER_BUTTON_TEMPLATE.instance() as Button
			
			module.get_node("GridContainer").add_child(new_button)
			
			new_button["custom_styles/normal"] = normal_style
			new_button["custom_styles/hover"] = hover_style
			new_button["custom_styles/pressed"] = pressed_style
			
			new_button.connect("pressed", self, "_change_player_class", [player_index, class_index])
	pass


func _change_player_class(player_index : int, new_class_index : int) -> void:
	$CharacterSelectSound.play()
	var player_class = Global.classes[new_class_index]
	Global.selected_classes[player_index] = player_class
	reset()
	pass
