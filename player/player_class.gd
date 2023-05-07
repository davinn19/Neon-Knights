class_name PlayerClass
extends Resource

enum MoveSpeed { NONE = 0, SLOW = 400, MEDIUM = 450, FAST = 500 }
enum SaberSize { NONE = 0, SHORT = 1, MEDIUM = 2, LONG = 3 }

export var name : String
export (SaberSize) var _saber_size
export (MoveSpeed) var _move_speed
export var max_special_meter : int
export var material : Material
export var color : Color
export (String, MULTILINE) var special_description

export var special_script : Script


func get_move_speed() -> int:
	return _move_speed

func get_move_speed_string() -> String:
	match _move_speed:
		MoveSpeed.SLOW:
			return "Slow"
		MoveSpeed.MEDIUM:
			return "Medium"
		MoveSpeed.FAST:
			return "Fast"
	
	return "???"

func get_saber_size() -> float:
	return _saber_size * 0.25 + 0.5


func get_saber_size_string() -> String:
	match _saber_size:
		SaberSize.SHORT:
			return "Short"
		SaberSize.MEDIUM:
			return "Medium"
		SaberSize.LONG:
			return "Long"
	
	return "???"
