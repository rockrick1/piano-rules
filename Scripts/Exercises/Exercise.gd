class_name Exercise
extends Node

@export var input_reader : InputReader
@export var exercise_controller : ExerciseController

var combo : int = 0
var max_combo : int = 0
var live_notes : Array[Note]

func setup(input_reader : InputReader, exercise_controller : ExerciseController):
    self.input_reader = input_reader
    self.exercise_controller = exercise_controller

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
