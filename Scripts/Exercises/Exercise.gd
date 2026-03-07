class_name Exercise
extends Node

enum Type {
    RANDOM_NOTE,
    RHYTHM_GAME
}

signal wrong_note_played(Note)
signal note_hit(Note)
signal note_missed(Note)

var input_reader : InputReader
var combo : int = 0
var max_combo : int = 0
var live_notes : Array[Note]

func setup(input_reader : InputReader):
    self.input_reader = input_reader

func next_step():
    pass

func create_note_in_scale() -> Note:
    return Note.create_in_scale(
        ExerciseContext.scale_letter,
        ExerciseContext.scale_accidental,
        ExerciseContext.scale_type,
        ExerciseContext.pitch_range[0],
        ExerciseContext.pitch_range[1]
    )

func _process(_delta) -> void:
    input_reader.just_pressed.clear()
    input_reader.just_released.clear()

func _is_note_in_array(note: Note, notes: Array[Note]) -> bool:
    for n in notes:
        if n.pitch == note.pitch:
            return true
    return false

func get_pressed_keys():
    return input_reader.currently_pressed.keys()

func get_just_pressed_keys():
    return input_reader.just_pressed.keys()

func get_just_released_keys():
    return input_reader.just_released.keys()

func is_key_pressed(pitch):
    return input_reader.currently_pressed.has(pitch)

func is_key_just_pressed(pitch):
    return input_reader.just_pressed.has(pitch)

func is_key_just_released(pitch):
    return input_reader.just_released.has(pitch)
