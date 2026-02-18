class_name RhythmGame
extends Exercise

const OFFSET := 4

var last_pitch : int = -1

func _ready():
    next_step()

func _spawn_random_note():
    var pitch := _get_random_pitch()
    live_notes.append(Note.new(pitch))
    last_pitch = pitch

func _get_random_pitch() -> int:
    if last_pitch == -1:
        return randi() % (exercise_controller.pitch_range[1] - exercise_controller.pitch_range[0]) + exercise_controller.pitch_range[0]
    
    var result := last_pitch
    while result == last_pitch:
        var offset := (randi() % (OFFSET * 2)) - OFFSET # TODO configure offset
        result = clamp(last_pitch + offset, exercise_controller.pitch_range[0], exercise_controller.pitch_range[1])
    
    return result

func next_step():
    _spawn_random_note()
