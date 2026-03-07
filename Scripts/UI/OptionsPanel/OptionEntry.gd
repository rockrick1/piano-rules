class_name OptionEntry
extends Node

@export var blocked_exercises : Array[Exercise.Type]

func _ready() -> void:
    if ExerciseContext.type in blocked_exercises:
        queue_free()
