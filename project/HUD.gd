extends CanvasLayer

# signals
signal build(station_name)

# enums

# constants

# exported variables

# variables
var _ignore
var _seconds := 0
var _minutes := 6

# onready variables
onready var _clock := $TimerLabel
onready var _vapor_label := $VaporLabel
onready var _ore_label := $OreLabel


func _ready()->void:
	_update_clock()


func _update_clock()->void:
	_clock.text = str(_minutes)+":"
	if _seconds < 10:
		_clock.text += "0"
	_clock.text += str(_seconds)


func _on_CondenserButton_pressed()->void:
	emit_signal("build", "condenser")


func _on_MineButton_pressed()->void:
	emit_signal("build", "mine")


func _on_CollecterButton_pressed()->void:
	emit_signal("build", "collector")


func _on_DrillButton_pressed()->void:
	emit_signal("build", "drill")


func _on_GameTimer_timeout()->void:
	_seconds -= 1
	if _seconds < 0:
		_seconds = 59
		_minutes -= 1
	_update_clock()
	if _seconds < 0 and _minutes < 0:
		print("YOU DEAD")


func _on_Main_update_display(vapor:int, ore:int)->void:
	_ore_label.text = str(ore)
	_vapor_label.text = str(vapor)
