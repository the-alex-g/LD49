extends FileInfo

# signals
signal update_file(target_file_name, new_energy_cost, new_material_cost, new_worker_cost)
signal maxed(target_file_name)

# enums

# constants

# exported variables

# variables
var _ignore
var _mining_progression := 0
var _housing_progression := 0
var _science_progression := 0
var _power_progression := 0

# onready variables



func _on_File_clicked(field_name:String)->void:
	match field_name:
		"Mining":
			_advance_research("mining")
		"Housing":
			_advance_research("housing")
		"Science":
			_advance_research("science")
		"Power":
			_advance_research("power")


func _advance_research(field:String)->void:
	var uppercase_field := field.to_upper()
	var progression_tracker_name := "_"+field+"_progression"
	var current_progression:int = get(progression_tracker_name)
	if current_progression+1 < 3:
		var next_level:Dictionary = get(uppercase_field+"_PROGRESSION")[current_progression+1]
		set(progression_tracker_name, current_progression+1)
		emit_signal("update_file", field.capitalize(), next_level["energy"], next_level["material"], next_level["workers"])
	else:
		emit_signal("maxed", field.capitalize())
