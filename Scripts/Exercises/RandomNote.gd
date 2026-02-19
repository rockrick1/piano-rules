class_name RandomNote
extends Exercise

var last_pitch : int = -1

func _ready():
    next_step()

func _process(_delta) -> void:
    if len(live_notes) == 0:
        return
    if len(get_just_pressed_keys()) == 0:
        return
    
    var pitch = get_just_pressed_keys()[0]
    var required_note := live_notes[0]
    var pressed_note := Note.new(pitch)
    # hit!
    if required_note.pitch == pressed_note.pitch:
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
    
    super._process(_delta)

func next_step():
    live_notes.remove_at(0)
    _spawn_random_note()

# generates a random pitch value, different from the last
func _spawn_random_note():
    var pitch := last_pitch
    var note := Note.new(pitch)
    # if accidentals are disabled, keep generating a new note until it doesn't have one
    while true:
        note = exercise_controller.create_note_in_scale()
        if note.pitch != last_pitch:
            break
    
    live_notes.append(note)
    last_pitch = pitch
