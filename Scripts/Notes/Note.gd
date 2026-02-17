class_name Note
extends Node2D

var type : String = "semibreve"
var accidental : NoteMapping.Accidental
var pitch : int
var note_str : String
var alive : bool = true

@export var shake_offset: float


func _ready():
    var mat: Material = $NoteSprite.get_material()
    mat.set_shader_parameter("strength", 0.0)

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

func sharp():
    accidental = NoteMapping.Accidental.SHARP
    $FlatSprite.set_visible(false)
    $SharpSprite.set_visible(true)

func flat():
    accidental = NoteMapping.Accidental.FLAT
    $FlatSprite.set_visible(true)
    $SharpSprite.set_visible(false)

func regular():
    accidental = NoteMapping.Accidental.REGULAR
    $FlatSprite.set_visible(false)
    $SharpSprite.set_visible(false)

func die():
    queue_free()
