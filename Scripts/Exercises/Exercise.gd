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

func _process(_delta) -> void:
    if len(live_notes) == 0:
        return
    if len(get_just_pressed_keys()) == 0:
        return
    
    var pitch = get_just_pressed_keys()[0]
    var required_note := live_notes[0]
    var pressed_note := Note.new(pitch)
    # hit!
    if required_note.pitch == pressed_note.pitch or \
    (exercise_controller.any_octave && pressed_note.letter == required_note.letter && \
    pressed_note.accidental == required_note.accidental):
        print("you got it bro!")
        required_note.hit.emit()
        combo += 1
        max_combo = max(max_combo, combo)
        next_step()
    # wrong note pressed :(
    else:
        print("man, u suck...")
        required_note.miss.emit()
        combo = 0
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
