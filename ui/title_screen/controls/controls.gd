extends Submenu

const PLAYERS : PoolStringArray = PoolStringArray(["p1","p2"])
const CONTROLS : PoolStringArray = PoolStringArray(["up", "down", "weak", "medium", "strong", "special"])

onready var control_buttons : Control = $VSplitContainer/GridContainer as Control
onready var remap_screen : Control = get_node("../../ControlRemap")

var remapping_input_action : String

func _ready() -> void:
	._ready()
	_connect_buttons()
	_set_remap_screen(false)
			

func reset() -> void:
	for player in PLAYERS:
		for control in CONTROLS:
			var input_name : String = player + "_" + control
			var input_key = InputMap.get_action_list(input_name)[0]
			
			_set_control_button_name(input_name, input_key)
	pass


func _set_control_button_name(input_name : String, input_key : InputEventKey) -> void:
	var button : Button = _get_control_button(input_name)
	var key_name : String = OS.get_scancode_string(input_key.scancode)
	button.text = key_name


func _get_control_button(input_name : String) -> Button:
	return control_buttons.get_node(input_name) as Button
	

func _connect_buttons() -> void:
	for player in PLAYERS:
		for control in CONTROLS:
			var input_name : String = player + "_" + control
			var control_button = _get_control_button(input_name)
			control_button.connect("pressed", self, "_on_control_button_pressed", [player, control])
	pass


func _on_control_button_pressed(player : String, control : String) -> void:
	remapping_input_action = player + "_" + control
	_set_remap_screen(true)
	pass
	
	
func _input(event : InputEvent):
	if event is InputEventKey and event.is_pressed():
		InputMap.action_erase_events(remapping_input_action)
		InputMap.action_add_event(remapping_input_action, event)
		_set_remap_screen(false)
		reset()
		
	pass


func _set_remap_screen(is_active : bool) -> void:
	if is_active:
		set_process_input(true)
		remap_screen.visible = true
	else:
		set_process_input(false)
		remap_screen.visible = false

