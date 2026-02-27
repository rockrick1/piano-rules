class_name NoteView
extends Node2D

@export var shake_offset : float

@onready var mat : Material = $NoteSprite.get_material()

var type := "semibreve"
var note : Note = null

func _ready():
    mat.set_shader_parameter("strength", 0.0)

func setup(note : Note):
    self.note = note
    match note.accidental:
        Note.Accidental.REGULAR:
            _regular()
        Note.Accidental.SHARP:
            _sharp()
        Note.Accidental.FLAT:
            _flat()

func play_miss():
    $AnimationPlayer.stop()
    $AnimationPlayer.play("miss")

func play_hit():
    $AnimationPlayer.stop()
    $AnimationPlayer.play("hit")

func _process(delta):
    $NoteSprite.offset.x = shake_offset
    $FlatSprite.offset.x = shake_offset
    $SharpSprite.offset.x = shake_offset

func _sharp():
    $FlatSprite.set_visible(false)
    $SharpSprite.set_visible(true)

func _flat():
    $FlatSprite.set_visible(true)
    $SharpSprite.set_visible(false)

func _regular():
    $FlatSprite.set_visible(false)
    $SharpSprite.set_visible(false)
