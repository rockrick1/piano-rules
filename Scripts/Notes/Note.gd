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

var type : String = "semibreve"
var octave : int
var letter : Letter
var accidental : Accidental
var pitch : int

func _init(pitch : int) -> void:
    self.pitch = pitch
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