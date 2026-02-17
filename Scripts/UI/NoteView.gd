class_name NoteView
extends Node2D

var type : String = "semibreve"
var note : Note
var alive : bool = true

@export var shake_offset: float

func _ready():
    var mat: Material = $NoteSprite.get_material()
    mat.set_shader_parameter("strength", 0.0)

func setup(_note : Note):
    note = _note
    match _note.accidental:
        Note.Accidental.REGULAR:
            _regular()
        Note.Accidental.SHARP:
            _sharp()
        Note.Accidental.FLAT:
            _flat()

func _process(delta):
    $NoteSprite.offset.x = shake_offset
    $FlatSprite.offset.x = shake_offset
    $SharpSprite.offset.x = shake_offset

func miss():
    $AnimationPlayer.stop()
    $AnimationPlayer.play("miss")

func hit():
    if not alive:
        return
    alive = false
    $AnimationPlayer.stop()
    $AnimationPlayer.play("hit")

func _sharp():
    $FlatSprite.set_visible(false)
    $SharpSprite.set_visible(true)

func _flat():
    $FlatSprite.set_visible(true)
    $SharpSprite.set_visible(false)

func _regular():
    $FlatSprite.set_visible(false)
    $SharpSprite.set_visible(false)
