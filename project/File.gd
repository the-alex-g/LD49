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
	_update_resources(str(energy_required),str(material_required),str(workers_required))
	_field_name_label.text = field_name


func _process(_delta:float)->void:
	if _is_hovered:
		if Input.is_action_just_pressed("left_click"):
			emit_signal("was_clicked", field_name)


func _update_resources(new_energy:String, new_material:String, new_workers:String)->void:
	_energy_required_label.text = new_energy
	_material_required_label.text = new_material
	_workers_required_label.text = new_workers


func _on_File_mouse_entered()->void:
	_is_hovered = true


func _on_File_mouse_exited()->void:
	_is_hovered = false


func _on_Main_update_file(target_file_name:String, new_energy_cost:int, new_material_cost:int, new_worker_cost:int)->void:
	if target_file_name == field_name:
		_update_resources(str(new_energy_cost), str(new_material_cost), str(new_worker_cost))


func _on_Main_maxed(target_file_name:String)->void:
	if field_name == target_file_name:
		_update_resources("-", "-", "-")
