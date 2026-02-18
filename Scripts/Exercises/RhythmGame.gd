class_name RhythmGame
extends Exercise

var OFFSET := 4
var START_TIME := 300
var SPEED := 150
var NPS : float = 1.0
var HIT_TIME_WINDOW : float = .3

var last_pitch : int = -1
var note_spawn_timer

func _ready():
    next_step()

func _process(delta : float) -> void:
    # move notes
    for note in live_notes:
        note.time -= SPEED * delta
    
    # check note spawn
    note_spawn_timer += delta
    if (note_spawn_timer > 1 / NPS):
        next_step()
    
    # kill missed notes
    while len(live_notes) > 0 && live_notes[0].time < -HIT_TIME_WINDOW * SPEED:
        live_notes[0].miss.emit()
        live_notes.remove_at(0)

func _spawn_random_note():
    var pitch := _get_random_pitch()
    live_notes.append(Note.new(pitch, START_TIME))
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
    note_spawn_timer = 0
    _spawn_random_note()
