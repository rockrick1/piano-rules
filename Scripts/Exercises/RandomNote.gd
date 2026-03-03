class_name RandomNote
extends Exercise

var last_pitch : int = -1

func _ready():
    next_step()

func _process(_delta) -> void:
    if len(live_notes) == 0:
        return
#    if Input.is_key_pressed(KEY_F):
#        wrong_note_played.emit(Note.new((randi() % 10) + 60))
    
    if len(get_just_pressed_keys()) == 0:
        return
    
    var pitch = get_just_pressed_keys()[0]
    var required_note := live_notes[0]
    var pressed_note := Note.new(pitch)
    # hit!
    if required_note.pitch == pressed_note.pitch:
        note_hit.emit(pressed_note)
        combo += 1
        max_combo = max(max_combo, combo)
        next_step()
    # wrong note pressed :(
    else:
        wrong_note_played.emit(pressed_note)
        combo = 0
    
    super._process(_delta)

func next_step():
    if len(live_notes) > 0:
        note_hit.emit(live_notes[0])
        live_notes.remove_at(0)
    _spawn_random_note()

# generates a random pitch value, different from the last
func _spawn_random_note():
    var note : Note
    while true:
        note = create_note_in_scale()
        if note.pitch != last_pitch:
            break
    
    note.time = note.pitch - 65
    live_notes.append(note)
    last_pitch = note.pitch
