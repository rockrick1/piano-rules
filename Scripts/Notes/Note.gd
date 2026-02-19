class_name Note

enum Accidental {
    REGULAR,
    SHARP,
    FLAT
}

enum Letter {
    C,
    D,
    E,
    F,
    G,
    A,
    B
}

signal hit
signal miss

var type : String = "semibreve"
var octave : int
var letter : Letter
var accidental : Accidental
var pitch : int
var time : float

func _init(pitch : int, time : float = 0) -> void:
    self.pitch = pitch
    self.time = time
    octave = pitch / 12 + 1
    var note_index := pitch % 12
    match note_index:
        0:
            letter = Letter.C
            accidental = Accidental.REGULAR
        1:
            letter = Letter.C
            accidental = Accidental.SHARP
        2:
            letter = Letter.D
            accidental = Accidental.REGULAR
        3:
            letter = Letter.D
            accidental = Accidental.SHARP
        4:
            letter = Letter.E
            accidental = Accidental.REGULAR
        5:
            letter = Letter.F
            accidental = Accidental.REGULAR
        6:
            letter = Letter.F
            accidental = Accidental.SHARP
        7:
            letter = Letter.G
            accidental = Accidental.REGULAR
        8:
            letter = Letter.G
            accidental = Accidental.SHARP
        9:
            letter = Letter.A
            accidental = Accidental.REGULAR
        10:
            letter = Letter.A
            accidental = Accidental.SHARP
        11:
            letter = Letter.B
            accidental = Accidental.REGULAR

static func create_in_scale(
    root_letter : Letter,
    root_accidental : Accidental,
    scale : Scale.Type,
    min_pitch : int,
    max_pitch : int,
    time : float = 0.0
) -> Note:
    var valid_pitches : Array[int] = []
    var root_pitch_class := _letter_to_pitch_class(root_letter)

    match root_accidental:
        Accidental.SHARP:
            root_pitch_class += 1
        Accidental.FLAT:
            root_pitch_class -= 1

    root_pitch_class = (root_pitch_class + 12) % 12

    # Collect all pitches in range that belong to scale
    for p in range(min_pitch, max_pitch + 1):
        var relative := (p - root_pitch_class) % 12
        if relative < 0:
            relative += 12

        if relative in Scale.INTERVALS[scale]:
            valid_pitches.append(p)

    if valid_pitches.is_empty():
        push_error("No valid notes found in scale and range.")
        return null

    var chosen_pitch : int = valid_pitches[randi() % valid_pitches.size()]
    return Note.new(chosen_pitch, time)

static func _letter_to_pitch_class(letter : Letter) -> int:
    match letter:
        Letter.C: return 0
        Letter.D: return 2
        Letter.E: return 4
        Letter.F: return 5
        Letter.G: return 7
        Letter.A: return 9
        Letter.B: return 11
    return 0

func _to_string() -> String:
    var accidental_str : String
    match self.accidental:
        Accidental.FLAT:
            accidental_str = "b"
        Accidental.SHARP:
            accidental_str = "#"
        _:
            accidental_str = ""
    return str(octave) + str(letter) + accidental_str
