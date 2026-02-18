class_name NoteView
extends Node2D

@export var shake_offset : float

@onready var mat : Material = $NoteSprite.get_material()

var type := "semibreve"
var note : Note = null
var alive := true

func _ready():
    mat.set_shader_parameter("strength", 0.0)

func setup(note : Note):
    if self.note != null:
        self.note.hit.disconnect(_on_hit)
        self.note.miss.disconnect(_on_miss)
    self.note = note
    self.note.hit.connect(_on_hit)
    self.note.miss.connect(_on_miss)
    match note.accidental:
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

func _on_miss():
    $AnimationPlayer.stop()
    $AnimationPlayer.play("miss")

func _on_hit():
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
