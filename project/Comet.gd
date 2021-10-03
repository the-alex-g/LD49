extends Node2D

# signals
signal update_display(vapor, ore)

# enums

# constants
const COLLECTOR := {"vapor":3, "ore":12}
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
onready var _available_collectors := [$Tail/Collecter, $Tail/Collecter2, $Tail/Collecter3, $Tail/Collecter4, $Tail/Collecter5, $Tail/Collecter6]
onready var _available_mines := [$Head/Mine, $Head/Mine2, $Head/Mine3]
onready var _available_drills := [$Head/Drill, $Head/Drill2, $Head/Drill3, $Head/Drill4, $Head/Drill5, $Head/Drill6]
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


func increment_ore()->void:
	_ore += 1
	emit_signal("update_display", _vapor, _ore)


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
	var station_name_capitalized := station_name.to_upper()
	var station_resources:Dictionary = get(station_name_capitalized)
	var available_stations:Array = get("_available_"+station_name+"s")
	if station_resources["vapor"] <= _vapor and station_resources["ore"] <= _ore and available_stations.size() > 0:
		if _first_built:
			_reset_timer()
			_first_built = false
		_vapor -= station_resources["vapor"]
		_ore -= station_resources["ore"]
		emit_signal("update_display", _vapor, _ore)
		var station_index := randi()%available_stations.size()
		var station:Station = available_stations[station_index]
		station.build()
		available_stations.remove(station_index)
		var station_info := {}
		station_info["station"] = station
		station_info["type"] = station_name
		_built_stations.append(station_info)


func _reset_timer()->void:
	var time_until_next_explosion := (BASE_EXPLODE_TIME+randi()%20)-10
	_explode_timer.start(time_until_next_explosion)


func _on_ExplodeTimer_timeout()->void:
	var doomed_station_index := randi()%_built_stations.size()
	var doomed_station:Station = _built_stations[doomed_station_index]["station"]
	var doomed_station_type:String = _built_stations[doomed_station_index]["type"]
	var available_stations:Array = get("_available_"+doomed_station_type+"s")
	available_stations.append(doomed_station)
	doomed_station.destroy()
	_reset_timer()
