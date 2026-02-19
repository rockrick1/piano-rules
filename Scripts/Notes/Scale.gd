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
