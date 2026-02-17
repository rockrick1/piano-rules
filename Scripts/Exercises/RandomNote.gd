class_name RandomNote
extends Exercise

var last_pitch : int = -1
var pitch_range : Array

func _init(controller):
    exercise_controller = controller
    pitch_range = exercise_controller.pitch_range
    next_step()

func _delete_current_notes():
    exercise_controller.kill_all_notes()

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
    exercise_controller.add_note(note)
    last_pitch = pitch
    print("created note at %s" % pitch)

func _get_random_pitch() -> int:
    return randi() % (pitch_range[1] - pitch_range[0]) + pitch_range[0]

func next_step():
    _spawn_random_note()
