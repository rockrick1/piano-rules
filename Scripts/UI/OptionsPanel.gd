extends PopupMenu

@export var note_range_scene : PackedScene

var EC : Node # ExerciseController

var is_mouse_inside : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_add_config_options()

func _input(event):
	if Input.is_action_pressed("left_mouse") and not is_mouse_inside:
		hide()

################################################################################

func _add_config_options():
	add_radio_check_item("Assist mode", 1)
	add_radio_check_item("Hard assist mode", 2)
	
	add_separator("", 10)
	
	add_item("Note range", 11)
	add_check_item("Accidentals", 12)
	set_item_checked(get_item_index(12), true)
	
	add_separator("", 20)
	
	add_check_item("Any octave", 21)
	set_item_tooltip(get_item_index(21), "Play the displayed note in any octave")
	
	add_separator("", 30)
	
	add_item("Refresh MIDI inputs", 50)
	add_item("Quit", 100)

func _on_OptionsPanel_id_pressed(id):
	var idx = get_item_index(id)
	match id:
		1:
			EC.assist_mode = not EC.assist_mode
			EC.hard_assist_mode = false
			EC.Assist.visible = EC.assist_mode
			EC.HardAssist.visible = EC.hard_assist_mode
			var hard_assist_idx = get_item_index(2)
			set_item_checked(idx, EC.assist_mode)
			set_item_checked(hard_assist_idx, EC.hard_assist_mode)
		2:
			EC.hard_assist_mode = not EC.hard_assist_mode
			EC.assist_mode = false
			EC.Assist.visible = EC.assist_mode
			EC.HardAssist.visible = EC.hard_assist_mode
			var assist_idx = get_item_index(1)
			set_item_checked(idx, EC.hard_assist_mode)
			set_item_checked(assist_idx, EC.assist_mode)
		11:
			if EC.note_range_open:
				return
			var note_range : NoteRange = note_range_scene.instantiate()
			note_range.init(EC)
			EC.add_child(note_range)
			note_range.visible = true
			EC.note_range_open = true
		12:
			EC.accidentals = not EC.accidentals
			set_item_checked(idx, EC.accidentals)
		21:
			EC.any_octave = not EC.any_octave
			set_item_checked(idx, EC.any_octave)
		50:
			OS.open_midi_inputs()
			hide()
		100:
			get_tree().quit()


func _on_OptionsPanel_mouse_entered():
	is_mouse_inside = true


func _on_OptionsPanel_mouse_exited():
	is_mouse_inside = false
