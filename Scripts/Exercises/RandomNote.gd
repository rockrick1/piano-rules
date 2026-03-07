class_name RandomNote
extends Exercise

func _ready():
    next_step()

func _process(_delta) -> void:
    if len(live_notes) == 0:
        return
#    if Input.is_key_pressed(KEY_F):
#        wrong_note_played.emit(Note.new((randi() % 10) + 60))
    
    _check_for_miss_feedback()
    _check_for_win_condition()
    
    super._process(_delta)

func next_step():
    live_notes.clear()
    _spawn_random_notes()

func _spawn_random_notes():
    var notes_to_spawn := ExerciseContext.simultaneous_notes
    while notes_to_spawn > 0:
        var note : Note = create_note_in_scale()
        if !_is_note_in_array(note, live_notes):
            note.time = note.pitch - 65
            live_notes.append(note)
            notes_to_spawn -= 1

func _check_for_miss_feedback() -> void:
    var input_pitches = get_just_pressed_keys()
    if len(input_pitches) == 0:
        return
    
    for input_pitch in input_pitches:
        var note := Note.new(input_pitch)
        if !_is_note_in_array(note, live_notes):
            note_missed.emit(note)

func _check_for_win_condition() -> void:
    var input_pitches = get_pressed_keys()
    if len(input_pitches) == 0:
        return
    
    var hit_count := 0
    for input_pitch in input_pitches:
        if _is_note_in_array(Note.new(input_pitch), live_notes):
            hit_count += 1
    
    if hit_count < len(live_notes):
        return
    
    for note in live_notes:
        note_hit.emit(note)
    
    next_step()
