extends Node2D

# signals
signal build(station_name)

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables



func _on_HUD_build(station_name:String)->void:
	emit_signal("build", station_name)
