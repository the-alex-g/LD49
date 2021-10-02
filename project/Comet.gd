extends Node2D

# signals
signal update_display(vapor, ore)

# enums

# constants

# exported variables

# variables
var _ignore
var _vapor := 0
var _ore := 0
var _tail_hovered := false
var _head_hovered := false

# onready variables


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
