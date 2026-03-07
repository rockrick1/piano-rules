extends OptionEntry

@export var toggle : CheckButton

func _ready() -> void:
    super._ready()
    toggle.toggled.connect(_on_toggle)
    toggle.toggle_mode = ExerciseContext.hard_assist

func _on_toggle(toggled: bool):
    ExerciseContext.hard_assist = toggled
