extends Control

# signals

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables



func _on_Button_pressed()->void:
	_ignore = get_tree().change_scene("res://Main.tscn")
