class_name RandomNote
extends Exercise

var last_note : int = -1
var pitch_range : Array

func _init(controller):
    ExerciseController = controller
    pitch_range = ExerciseController.pitch_range
    next_step()

################################################################################

func _delete_current_notes():
    ExerciseController.kill_all_notes()

# generates a random pitch value, different from the last
func _spawn_random_note():
    var note := last_note
    var note_str
    if note > - 1:
        note_str = NoteMapping.notes[note]
    # if accidentals are disabled, keep generating a new note until it doesn't have one
    if !ExerciseController.accidentals:
        while note == last_note or "#" in note_str or "b" in note_str:
            note = randi() % (pitch_range[1] - pitch_range[0]) + pitch_range[0]
            note_str = NoteMapping.notes[note]
    ExerciseController.add_note(note)
    last_note = note

func next_step():
    _spawn_random_note()
