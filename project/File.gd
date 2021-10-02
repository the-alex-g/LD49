extends Area2D

# signals
signal was_clicked(field_name)

# enums

# constants

# exported variables
export var energy_required := 0
export var material_required := 0
export var workers_required := 0
export var field_name := ""

# variables
var _ignore
var _is_hovered := false

# onready variables
onready var _energy_required_label := $FileImage/ResourcesImage/EnergyLabel
onready var _material_required_label := $FileImage/ResourcesImage/MaterialLabel
onready var _workers_required_label := $FileImage/ResourcesImage/WorkerLabel
onready var _field_name_label := $FieldName

func _ready()->void:
	_energy_required_label.text = str(energy_required)
	_material_required_label.text = str(material_required)
	_workers_required_label.text = str(workers_required)
	_field_name_label.text = field_name


func _process(_delta:float)->void:
	if _is_hovered:
		if Input.is_action_just_pressed("left_click"):
			emit_signal("was_clicked", field_name)


func _on_File_mouse_entered()->void:
	_is_hovered = true


func _on_File_mouse_exited()->void:
	_is_hovered = false
