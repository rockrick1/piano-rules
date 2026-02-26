class_name Scale

enum Type {
    ANY,
    MAJOR,
    NATURAL_MINOR
}

const INTERVALS: Dictionary[Type, Array] = {
    Type.ANY : [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
    Type.MAJOR : [0, 2, 4, 5, 7, 9, 11],
    Type.NATURAL_MINOR : [0, 2, 3, 5, 7, 8, 10],
}

static func get_scale_string(scale: Scale.Type, accidental: Note.Accidental, letter: Note.Letter) -> String:
    var accidental_str : String
    match accidental:
        Note.Accidental.FLAT:
            accidental_str = "b"
        Note.Accidental.SHARP:
            accidental_str = "#"
        _:
            accidental_str = ""
    return "%s%s %s" % [Note.Letter.keys()[letter], accidental_str, Scale.Type.keys()[scale]]