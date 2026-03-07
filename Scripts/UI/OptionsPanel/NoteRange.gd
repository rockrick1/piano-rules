class_name NoteRange
extends OptionsSubPanel

signal range_changed

@export var presets_container : Control
@export var preset_button_scene : PackedScene
@export var start_label : Control
@export var end_label : Control

var presets : Dictionary = {
    "Treble" : [60, 85],
    "Bass" : [40, 60],
    "Full" : [40, 85]
}

func _ready() -> void:
    _update_visuals()
    _populate_presets()

func enable():
    super.enable()
    range_changed.emit()

func _update_visuals():
    var start := Note.new(ExerciseContext.pitch_range[0])
    var end := Note.new(ExerciseContext.pitch_range[1])
    start_label.set_text(str(start))
    end_label.set_text(str(end))
    range_changed.emit()

func _on_start_up_pressed():
    if ExerciseContext.pitch_range[0] + 1 >= ExerciseContext.pitch_range[1]:
        return
    ExerciseContext.pitch_range[0] += 1
    _update_visuals()

func _on_start_down_pressed():
    ExerciseContext.pitch_range[0] -= 1
    _update_visuals()

func _on_end_up_pressed():
    ExerciseContext.pitch_range[1] += 1
    _update_visuals()

func _on_end_down_pressed():
    if ExerciseContext.pitch_range[1] - 1 <= ExerciseContext.pitch_range[0]:
        return
    ExerciseContext.pitch_range[1] -= 1
    _update_visuals()

func _populate_presets():
    for key in presets.keys():
        var button_instance : Button = preset_button_scene.instantiate()
        button_instance.text = key
        button_instance.pressed.connect(func ():
            _on_preset_pressed(key)
        )
        presets_container.add_child(button_instance)

func _on_preset_pressed(preset: String):
    var new_range = presets[preset]
    ExerciseContext.pitch_range[0] = new_range[0]
    ExerciseContext.pitch_range[1] = new_range[1]
    _update_visuals()
