extends Node2D

# signals
signal update_display(vapor, ore)
signal won
signal explosions_finished

# enums

# constants
const COLLECTOR := {"vapor":3, "ore":12}
const DRILL := {"vapor":5, "ore":10}
const MINE := {"vapor":10, "ore":20}
const CONDENSER := {"vapor":5, "ore":25}
const GRAV_FIELD := {"vapor":200, "ore":200}
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
var _is_game_running := true

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
	if _is_game_running:
		_vapor += 1
		emit_signal("update_display", _vapor, _ore)


func increment_ore()->void:
	if _is_game_running:
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
		_built_stations.append(station)


func _reset_timer()->void:
	var time_until_next_explosion := (BASE_EXPLODE_TIME+randi()%20)-10
	_explode_timer.start(time_until_next_explosion)


func _on_ExplodeTimer_timeout()->void:
	var doomed_station := _destroy_station()
	var doomed_station_type:String = doomed_station.type
	var available_stations:Array = get("_available_"+doomed_station_type+"s")
	available_stations.append(doomed_station)


func _on_Main_explode_stations()->void:
	var station_destroyed = _destroy_station()
	if station_destroyed == null:
		emit_signal("explosions_finished")
	_explode_timer.stop()
	_is_game_running = false


func _destroy_station()->Station:
	if _built_stations.size() > 0:
		var doomed_station_index := randi()%_built_stations.size()
		var doomed_station:Station = _built_stations[doomed_station_index]
		_built_stations.remove(doomed_station_index)
		doomed_station.destroy()
		_reset_timer()
		return doomed_station
	else:
		return null


func _on_station_exploded()->void:
	if not _is_game_running:
		var station_destroyed = _destroy_station()
		if station_destroyed == null:
			emit_signal("explosions_finished")


func _on_Main_build_grav_field()->void:
	if _vapor >= GRAV_FIELD["vapor"] and _ore >= GRAV_FIELD["ore"]:
		emit_signal("won")
		_is_game_running = false
		_explode_timer.stop()
