extends OptionEntry

@export var toggle : CheckButton
@export var hard_assist_toggle : CheckButton

func _ready() -> void:
    super._ready()
    toggle.pressed.connect(_on_pressed)
    toggle.button_pressed = ExerciseContext.assist

func _on_pressed():
    ExerciseContext.assist = toggle.button_pressed
    if ExerciseContext.hard_assist:
        ExerciseContext.hard_assist = false
        hard_assist_toggle.button_pressed = false
    ExerciseContext.notify_values_changed()
