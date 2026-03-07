class_name RhythmGame
extends Exercise

var OFFSET := 4
var START_TIME := 300.0
var SPEED := 150
var NPS : float = 1.0
var HIT_TIME_WINDOW : float = .3

var last_pitch : int = -1
var note_spawn_timer

func _ready():
    next_step()

func _process(delta : float) -> void:
    _process_note_movement(delta)
    _process_note_spawn(delta)
    _process_note_hitting()
    _process_note_missing()

func _process_note_movement(delta: float):
    if ExerciseContext.wait_for_note_played && len(live_notes) > 0 && live_notes[0].time <= 0:
        return
    
    for note in live_notes:
        note.time -= SPEED * delta

func _process_note_spawn(delta: float):
    if ExerciseContext.wait_for_note_played && len(live_notes) > 0 && live_notes[0].time <= 0:
        return
    
    note_spawn_timer += delta
    if (note_spawn_timer > 1 / NPS):
        next_step()

func _process_note_missing():
    if ExerciseContext.wait_for_note_played:
        return

    while len(live_notes) > 0 && live_notes[0].time < -HIT_TIME_WINDOW * SPEED:
        note_missed.emit(live_notes[0])
        live_notes.remove_at(0)

func _process_note_hitting():
    var last_note_time := 1.79769e308
    var hit_count := 0
    var needed_notes : Array[Note]
    for note in live_notes:
        if note.time > last_note_time:
            break
        
        needed_notes.append(note)
        last_note_time = note.time
    
    var input_pitches = get_pressed_keys()
    for input_pitch in input_pitches:
        var pressed_note = Note.new(input_pitch)
        if _is_note_in_array(pressed_note, needed_notes):
            hit_count += 1
    
    if hit_count == len(needed_notes):
        for note in needed_notes:
            note_hit.emit(note)
            live_notes.erase(note)

func next_step():
    note_spawn_timer = 0
    _spawn_random_notes()

func _spawn_random_notes():
    var notes_to_spawn := ExerciseContext.simultaneous_notes
    while notes_to_spawn > 0:
        var note : Note = create_note_in_scale()
        if !_is_note_in_array(note, live_notes):
            note.time = START_TIME
            live_notes.append(note)
            notes_to_spawn -= 1
