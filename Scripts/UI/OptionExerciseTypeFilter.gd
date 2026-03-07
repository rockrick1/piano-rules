extends Node

@export var allowed_exercises : Array[Exercise.Type]

func _ready() -> void:
    if ExerciseContext.type in allowed_exercises:
        return
    
    queue_free()
