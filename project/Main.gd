extends Node2D

# signals
signal build(station_name)
signal update_display(vapor, ore)

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables


func _ready()->void:
	randomize()


func _on_HUD_build(station_name:String)->void:
	emit_signal("build", station_name)


func _on_Comet_update_display(vapor:int, ore:int)->void:
	emit_signal("update_display", vapor, ore)
