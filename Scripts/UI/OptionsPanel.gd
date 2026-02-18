extends PopupMenu

@export var note_range_scene : PackedScene

var exercise_controller : ExerciseController

var is_mouse_inside : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
    _add_config_options()

func _input(event):
    if Input.is_action_pressed("left_mouse") and not is_mouse_inside:
        hide()

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
            exercise_controller.assist_mode = not exercise_controller.assist_mode
            exercise_controller.hard_assist_mode = false
            exercise_controller.assist.visible = exercise_controller.assist_mode
            exercise_controller.hard_assist.visible = exercise_controller.hard_assist_mode
            var hard_assist_idx = get_item_index(2)
            set_item_checked(idx, exercise_controller.assist_mode)
            set_item_checked(hard_assist_idx, exercise_controller.hard_assist_mode)
        2:
            exercise_controller.hard_assist_mode = not exercise_controller.hard_assist_mode
            exercise_controller.assist_mode = false
            exercise_controller.assist.visible = exercise_controller.assist_mode
            exercise_controller.hard_assist.visible = exercise_controller.hard_assist_mode
            var assist_idx = get_item_index(1)
            set_item_checked(idx, exercise_controller.hard_assist_mode)
            set_item_checked(assist_idx, exercise_controller.assist_mode)
        11:
            if exercise_controller.note_range_open:
                return
            var note_range : NoteRange = note_range_scene.instantiate()
            note_range.init(exercise_controller)
            exercise_controller.add_child(note_range)
            note_range.visible = true
            exercise_controller.note_range_open = true
        12:
            exercise_controller.accidentals = not exercise_controller.accidentals
            set_item_checked(idx, exercise_controller.accidentals)
        21:
            exercise_controller.any_octave = not exercise_controller.any_octave
            set_item_checked(idx, exercise_controller.any_octave)
        50:
            OS.open_midi_inputs()
            hide()
        100:
            get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")
            # TODO this shouldnt be needed
            get_tree().root.get_node("ExerciseView").queue_free()

func _on_OptionsPanel_mouse_entered():
    is_mouse_inside = true

func _on_OptionsPanel_mouse_exited():
    is_mouse_inside = false
