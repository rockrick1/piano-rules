class_name ExerciseController
extends Control

@export var note_scene : PackedScene

@onready var InputReader : Node
@onready var NoteGroup : Node
@onready var OptionsPanel : Node
@onready var Assist : Node
@onready var HardAssist : Node
@onready var Complements : Node

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
    
    # input reading scene
    InputReader = $InputReader
    
    # parent node for all the notes on screen
    NoteGroup = $MarginContainer/MarginContainer/TextureRect/Notes
    
    # options panel, with many settings
    OptionsPanel = $MarginContainer/Buttons/Configs/OptionsPanel
    OptionsPanel.EC = self
    
    # Assist nodes
    Assist = $MarginContainer/MarginContainer/TextureRect/Assist
    HardAssist = $MarginContainer/MarginContainer/TextureRect/HardAssist
    Complements = $MarginContainer/MarginContainer/TextureRect/Complements
    Assist.visible = false
    HardAssist.visible = false
    Complements.get_node("TopLine").hide()
    Complements.get_node("BotLine").hide()
    
    tone_offset = $MarginContainer/MarginContainer/TextureRect/Anchor77.position.y - $MarginContainer/MarginContainer/TextureRect/Anchor60.position.y
    tone_offset /= 10
    
    print(tone_offset)
    load_exercise(RandomNote.new(self))

func _process(_delta):
    # process note hits from input
    for note_view : NoteView in NoteGroup.get_children():
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
    InputReader.just_pressed.clear()
    InputReader.just_released.clear()

func load_exercise(exercise : Exercise):
    current_exercise = exercise

func get_note_position(note : Note) -> Vector2:
    var note_offset = NoteMapping.offsets[note.letter]
    var octave_offset = tone_offset * 7
    var dist = (note_offset * tone_offset) + ((note.octave - 6) * octave_offset)
    var pos = $MarginContainer/MarginContainer/TextureRect/Anchor60.position + Vector2(((note_offset + note.octave) % 2) * -50, dist)
    return pos

func add_note(note : Note):
    var note_view : NoteView = note_scene.instantiate()
    note_view.setup(note)
    note_view.position = get_note_position(note)
    $MarginContainer/MarginContainer/TextureRect/Notes.add_child(note_view)

# murders all notes on screen
func kill_all_notes():
    for note in NoteGroup.get_children():
        note.queue_free()

func get_pressed_keys():
    return InputReader.currently_pressed.keys()

func get_just_pressed_keys():
    return InputReader.just_pressed.keys()

func get_just_released_keys():
    return InputReader.just_released.keys()

func is_key_pressed(pitch):
    return InputReader.currently_pressed.has(pitch)

func is_key_just_pressed(pitch):
    return InputReader.just_pressed.has(pitch)

func is_key_just_released(pitch):
    return InputReader.just_released.has(pitch)


func _on_NextStep_pressed():
    kill_all_notes()
    current_exercise.next_step()

func _on_Configs_pressed():
    OptionsPanel.visible = not OptionsPanel.visible

func _set_combo(combo):
    self.combo = combo
    max_combo = max(max_combo, combo)
    $MarginContainer/Buttons/Combos/Combo.set_text("Combo: "+str(combo))
    $MarginContainer/Buttons/Combos/MaxCombo.set_text("Max: "+str(max_combo))
