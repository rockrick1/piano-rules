class_name RandomNote
extends Exercise

var last_pitch : int = -1

func _ready():
    next_step()

func next_step():
    live_notes.remove_at(0)
    _spawn_random_note()

# generates a random pitch value, different from the last
func _spawn_random_note():
    var pitch := last_pitch
    if last_pitch == -1:
        pitch = _get_random_pitch()
    
    var note := Note.new(pitch)
    # if accidentals are disabled, keep generating a new note until it doesn't have one
    while pitch == last_pitch or (!exercise_controller.accidentals && (note.accidental == Note.Accidental.SHARP or note.accidental == Note.Accidental.SHARP)):
        pitch = _get_random_pitch()
        note = Note.new(pitch)
    live_notes.append(note)
    last_pitch = pitch

func _get_random_pitch() -> int:
    return randi() % (exercise_controller.pitch_range[1] - exercise_controller.pitch_range[0]) + exercise_controller.pitch_range[0]
