extends Node2D

# signals
signal update_display(vapor, ore)

# enums

# constants
const COLLECTER := {"vapor":3, "ore":12}
const DRILL := {"vapor":5, "ore":10}
const MINE := {"vapor":10, "ore":20}
const CONDENSER := {"vapor":5, "ore":25}
const BASE_EXPLODE_TIME := 20

# exported variables

# variables
var _ignore
var _vapor := 0
var _ore := 0
var _tail_hovered := false
var _head_hovered := false
var _built_stations := []
var _first_built := true

# onready variables
onready var _available_condensers := [$Tail/Condenser, $Tail/Condenser2, $Tail/Condenser3]
onready var _explode_timer := $ExplodeTimer


func _process(_delta:float)->void:
		if Input.is_action_just_pressed("left_click"):
			if _tail_hovered:
				increment_vapor()
			elif _head_hovered:
				increment_ore()


func increment_vapor()->void:
	_vapor += 1
	emit_signal("update_display", _vapor, _ore)
	print(_vapor)


func increment_ore()->void:
	_ore += 1
	emit_signal("update_display", _vapor, _ore)
	print(_ore)


func _on_Tail_mouse_entered()->void:
	_tail_hovered = true
	_head_hovered = false


func _on_Tail_mouse_exited()->void:
	_tail_hovered = false


func _on_Head_mouse_entered()->void:
	_head_hovered = true
	_tail_hovered = false


func _on_Head_mouse_exited()->void:
	_head_hovered = false


func _on_Station_new_material(vapor, ore)->void:
	if vapor:
		increment_vapor()
	if ore:
		increment_ore()


func _on_Main_build(station_name:String)->void:
	if _first_built:
		_reset_timer()
	var station_name_capitalized := station_name.to_upper()
	var station_resources:Dictionary = get(station_name_capitalized)
	if station_resources["vapor"] <= _vapor and station_resources["ore"] <= _ore:
		var available_stations:Array = get("_available_"+station_name+"s")
		var station_index := randi()%available_stations.size()
		var station:Station = available_stations[station_index]
		station.build()
		available_stations.remove(station_index)
		_built_stations.append(station)


func _reset_timer()->void:
	var time_until_next_explosion := (BASE_EXPLODE_TIME+randi()%20)-10
	_explode_timer.start(time_until_next_explosion)


func _on_ExplodeTimer_timeout()->void:
	var doomed_station_index := randi()%_built_stations.size()
	var doomed_station:Station = _built_stations[doomed_station_index]
	doomed_station.destroy()
	_reset_timer()
