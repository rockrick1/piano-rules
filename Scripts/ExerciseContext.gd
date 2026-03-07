class_name ExerciseContext

static var type : Exercise.Type
static var pitch_range : Array[int] = [60,87]
static var scale_type := Scale.Type.MAJOR
static var scale_letter := Note.Letter.C
static var scale_accidental := Note.Accidental.REGULAR
static var simultaneous_notes := 1

#rhythm game specifics
static var wait_for_note_played := false
static var note_spawn_interval := 1.0
static var note_speed := 150.0
