extends Node

signal values_changed

var type : Exercise.Type
var pitch_range : Array[int] = [60,87]
var assist := false
var hard_assist := false
var scale_type := Scale.Type.MAJOR
var scale_letter := Note.Letter.C
var scale_accidental := Note.Accidental.REGULAR
var simultaneous_notes := 1

#rhythm game specifics
var wait_for_note_played := false
var note_spawn_interval := 1.0
var note_speed := 150.0

func notify_values_changed():
    values_changed.emit()
