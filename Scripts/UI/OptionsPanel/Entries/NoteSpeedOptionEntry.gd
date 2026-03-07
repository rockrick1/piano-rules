extends OptionEntry

@export var input : SpinBox

func _ready() -> void:
    super._ready()
    input.value_changed.connect(_on_value_changed)
    input.value = ExerciseContext.note_speed

func _on_value_changed(value: float):
    ExerciseContext.note_speed = value
