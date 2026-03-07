extends OptionEntry

@export var input : SpinBox

func _ready() -> void:
    super._ready()
    input.value_changed.connect(_on_value_changed)
    input.value = ExerciseContext.simultaneous_notes

func _on_value_changed(value: float):
    ExerciseContext.simultaneous_notes = int(value)
