class_name ExerciseController
extends Control

@export var note_scene : PackedScene

@export var input_reader : InputReader
@export var note_group : Node
@export var options_panel : Node
@export var assist : Node
@export var hard_assist : Node
@export var complements : Node
@export var combo_label : Label
@export var max_combo_label : Label
@export var anchor_77 : Node2D
@export var anchor_60 : Node2D

var note_range_open : bool = false

var assist_mode : bool = false
var hard_assist_mode : bool = false
var pitch_range = [60,87]
var any_octave : bool = false
var accidentals : bool = true

var combo : int = 0
var max_combo : int = 0

var tone_offset : float

var current_exercise : Exercise

func _ready():
    # generate a new random seed
    randomize()
    
    # options panel, with many settings
    options_panel.exercise_controller = self
    
    # Assist nodes
    assist.visible = false
    hard_assist.visible = false
    complements.get_node("TopLine").hide()
    complements.get_node("BotLine").hide()
    
    tone_offset = anchor_77.position.y - anchor_60.position.y
    tone_offset /= 10
    
    print(tone_offset)
    load_exercise(RandomNote.new(self))

func _process(_delta):
    for note_view : NoteView in note_group.get_children():
        # doesn't consider notes that are on screen but have already been played
        # only considers one not, for now
        if (not note_view.alive) or len(get_just_pressed_keys()) == 0:
            continue
        var pitch = get_just_pressed_keys()[0]
        var pressed_note := Note.new(pitch)
        var required_note := Note.new(note_view.note.pitch)
        # hit!
        if required_note.pitch == pressed_note.pitch or (any_octave && pressed_note.letter == required_note.letter && pressed_note.accidental == required_note.accidental):
            print("you got it bro!")
            note_view.hit()
            _set_combo(combo + 1)
            current_exercise.next_step()
        # wrong note pressed :(
        else:
            print("man, u suck...")
            note_view.miss()
            _set_combo(0)
    input_reader.just_pressed.clear()
    input_reader.just_released.clear()

func load_exercise(exercise : Exercise):
    current_exercise = exercise

func _get_note_position(note : Note) -> Vector2:
    var note_offset : int = note.letter
    var octave_offset := tone_offset * 7
    var dist := (note_offset * tone_offset) + ((note.octave - 6) * octave_offset)
    var pos := anchor_60.position + Vector2.DOWN * dist
    return pos

func add_note(note : Note):
    var note_view : NoteView = note_scene.instantiate()
    note_view.setup(note)
    note_view.position = _get_note_position(note)
    note_group.add_child(note_view)

# murders all notes on screen
func kill_all_notes():
    for note in note_group.get_children():
        note.queue_free()

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


func _on_NextStep_pressed():
    kill_all_notes()
    current_exercise.next_step()

func _on_Configs_pressed():
    options_panel.visible = not options_panel.visible

func _set_combo(combo):
    self.combo = combo
    max_combo = max(max_combo, combo)
    combo_label.set_text("Combo: "+str(combo))
    max_combo_label.set_text("Max: "+str(max_combo))
