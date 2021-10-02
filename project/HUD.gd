extends CanvasLayer

# signals
signal build(station_name)

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables



func _on_CondenserButton_pressed()->void:
	emit_signal("build", "condenser")


func _on_MineButton_pressed()->void:
	emit_signal("build", "mine")


func _on_CollecterButton_pressed()->void:
	emit_signal("build", "collector")


func _on_DrillButton_pressed()->void:
	emit_signal("build", "drill")
