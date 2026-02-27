class_name ExerciseController
extends Control

@export var input_reader : InputReader
@export var exercise_parent : Node
@export var note_scene : PackedScene
@export var note_group : Node
@export var assist : Node
@export var hard_assist : Node
@export var complements : Node
@export var combo_label : Label
@export var max_combo_label : Label
@export var anchor_77 : Node2D
@export var anchor_60 : Node2D
@export var top_line : Line2D
@export var bot_line : Line2D

@export var options_panel : Control
@export var note_range : NoteRange

var tone_offset : float
var current_exercise : Exercise
var note_views : Array[NoteView]

func _ready():
    # generate a new random seed
    randomize()
    
    options_panel.exercise_controller = self
    
    assist.visible = false
    hard_assist.visible = false
    top_line.hide()
    bot_line.hide()
    
    tone_offset = anchor_77.position.y - anchor_60.position.y
    tone_offset /= 10
    
    note_range.enabled.connect(_on_note_range_enabled)
    note_range.disabled.connect(_on_note_range_disabled)
    note_range.range_changed.connect(_on_note_range_changed)

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

func set_assist_mode_active(active: bool) -> void:
    assist.visible = active

func set_hard_assist_mode_active(active: bool) -> void:
    hard_assist.visible = active

func _on_NextStep_pressed():
    current_exercise.next_step()

func _on_Configs_pressed():
    options_panel.show()

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

func _on_note_range_enabled():
    top_line.show()
    bot_line.show()

func _on_note_range_disabled():
    top_line.hide()
    bot_line.hide()

func _on_note_range_changed():
    var top_pos := Vector2(1024/2, get_note_position(Note.new(ExerciseContext.pitch_range[1])).y)
    top_line.set_position(top_pos)
    var bot_pos := Vector2(1024/2, get_note_position(Note.new(ExerciseContext.pitch_range[0])).y)
    bot_line.set_position(bot_pos)
