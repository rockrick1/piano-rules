extends Node

@export var controller_scene : PackedScene
@export var random_note_scene : PackedScene
@export var rhythm_game_scene : PackedScene

func _on_random_note_pressed() -> void:
    _load_exercise_scene(random_note_scene)

func _on_rhythm_game_pressed() -> void:
    _load_exercise_scene(rhythm_game_scene)

func _load_exercise_scene(exercise_scene : PackedScene) -> void:
    var controller : ExerciseController = controller_scene.instantiate()
    get_tree().root.add_child(controller)
    controller.load_exercise(exercise_scene)
    queue_free()
