class_name Station
extends Node2D

# signals
signal new_material(vapor,ore)
signal station_exploded

# enums

# constants

# exported variables
export var frequency := 0.0
export var vapor := false
export var ore := false
export var type := ""

# variables
var _ignore
var _is_exploding = false

# onready variables
onready var _sprite := $Sprite
onready var _timer := $Timer


func _ready()->void:
	hide()
	_timer.wait_time = frequency


func _on_Timer_timeout()->void:
	emit_signal("new_material", vapor, ore)


func build()->void:
	_sprite.play(type)
	show()
	_timer.start()


func destroy()->void:
	_sprite.play("explode")
	_is_exploding = true
	_timer.stop()


func _on_Sprite_animation_finished()->void:
	if _is_exploding:
		hide()
		emit_signal("station_exploded")
