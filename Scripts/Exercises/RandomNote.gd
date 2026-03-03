class_name RandomNote
extends Exercise

var pressed_pitches : Array[int] = []

func _ready():
    next_step()

func _process(_delta) -> void:
    if len(live_notes) == 0:
        return
#    if Input.is_key_pressed(KEY_F):
#        wrong_note_played.emit(Note.new((randi() % 10) + 60))

    _clear_released_keys()
    
    var input_pitches = get_just_pressed_keys()
    if len(input_pitches) == 0:
        return
    
    for input_pitch in input_pitches:
        if input_pitch not in pressed_pitches:
            var pressed_note := Note.new(input_pitch)
            pressed_pitches.append(input_pitch)
            if input_pitch == pressed_note.pitch:
                note_hit.emit(pressed_note)
                combo += 1
                max_combo = max(max_combo, combo)
            else:
                wrong_note_played.emit(pressed_note)
                combo = 0
    
    var hit_count := 0
    for note in live_notes:
        if note.pitch in pressed_pitches:
            hit_count += 1
    
    if hit_count == len(live_notes):
        next_step()
    
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

func _is_note_in_array(note: Note, notes: Array[Note]) -> bool:
    for n in notes:
        if n.pitch == note.pitch:
            return true
    return false

func _clear_released_keys():
    for pitch in get_just_released_keys():
        for i in len(pressed_pitches):
            var pressed := pressed_pitches[i]
            if pitch == pressed:
                pressed_pitches.remove_at(i)
                return
