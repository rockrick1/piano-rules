class_name ExerciseController
extends Control

@export var input_reader : InputReader
@export var exercise_parent : Node
@export var note_scene : PackedScene
@export var note_group : Node
@export var options_panel : Node
@export var assist : Node
@export var hard_assist : Node
@export var complements : Node
@export var combo_label : Label
@export var max_combo_label : Label
@export var anchor_77 : Node2D
@export var anchor_60 : Node2D

var note_range_open := false
var assist_mode := false
var hard_assist_mode := false
var pitch_range : Array[int] = [60,87]
var any_octave := false
var accidentals := true
var tone_offset : float
var current_exercise : Exercise
var note_views : Array[NoteView]

func _ready():
    # generate a new random seed
    randomize()
    
    options_panel.exercise_controller = self
    
    assist.visible = false
    hard_assist.visible = false
    complements.get_node("TopLine").hide()
    complements.get_node("BotLine").hide()
    
    tone_offset = anchor_77.position.y - anchor_60.position.y
    tone_offset /= 10

func _process(_delta: float) -> void:
    _update_notes()
    _update_combo()

func load_exercise(exercise_scene : PackedScene):
    var exercise_instance : Exercise = exercise_scene.instantiate()
    exercise_instance.setup(input_reader, self)
    exercise_parent.add_child(exercise_instance)
    current_exercise = exercise_instance

func get_note_position(note : Note) -> Vector2:
    var note_offset : int = note.letter
    var octave_offset := tone_offset * 7
    var y_pos := (note_offset * tone_offset) + ((note.octave - 6) * octave_offset)
    var x_pos := note.time
    var pos := anchor_60.position + Vector2(x_pos, y_pos)
    return pos

func _on_NextStep_pressed():
    current_exercise.next_step()

func _on_Configs_pressed():
    options_panel.visible = not options_panel.visible

func _update_notes():
    var live_note_count := len(current_exercise.live_notes)
    var missing_instances := live_note_count - len(note_views)
    for i in range(0, missing_instances):
        var note_view : NoteView = note_scene.instantiate()
        note_group.add_child(note_view)
        note_views.append(note_view)
    
    for i in range(0, len(note_views)):
        var active := i < live_note_count
        note_views[i].visible = active
        if !active:
            continue
        
        note_views[i].setup(current_exercise.live_notes[i])
        note_views[i].position = get_note_position(current_exercise.live_notes[i])

func _update_combo():
    combo_label.set_text("Combo: " + str(current_exercise.combo))
    max_combo_label.set_text("Max: " + str(current_exercise.max_combo))
