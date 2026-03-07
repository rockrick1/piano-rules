extends OptionEntry

@export var toggle : CheckButton
@export var assist_toggle : CheckButton

func _ready() -> void:
    super._ready()
    toggle.pressed.connect(_on_pressed)
    toggle.button_pressed = ExerciseContext.hard_assist

func _on_pressed():
    ExerciseContext.hard_assist = toggle.button_pressed
    if ExerciseContext.assist:
        ExerciseContext.assist = false
        assist_toggle.button_pressed = false
    ExerciseContext.notify_values_changed()
