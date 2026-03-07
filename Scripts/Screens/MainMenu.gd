extends Node

@export var controller_scene : PackedScene
@export var exercises : Dictionary[Exercise.Type, PackedScene]

func _on_random_note_pressed() -> void:
    _load_exercise_scene(Exercise.Type.RANDOM_NOTE)

func _on_rhythm_game_pressed() -> void:
    _load_exercise_scene(Exercise.Type.RHYTHM_GAME)

func _load_exercise_scene(type: Exercise.Type) -> void:
    var controller : ExerciseController = controller_scene.instantiate()
    ExerciseContext.type = type
    get_tree().root.add_child(controller)
    controller.load_exercise(exercises[type])
    queue_free()
