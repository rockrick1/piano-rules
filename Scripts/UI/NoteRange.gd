class_name NoteRange
extends OptionsSubPanel

signal range_changed

@export var start_label : Control
@export var end_label : Control

func _ready() -> void:
    var start := Note.new(ExerciseContext.pitch_range[0])
    var end := Note.new(ExerciseContext.pitch_range[1])
    start_label.set_text(str(start))
    end_label.set_text(str(end))

func enable():
    super.enable()
    range_changed.emit()

func _on_start_up_pressed():
    if ExerciseContext.pitch_range[0] + 1 >= ExerciseContext.pitch_range[1]:
        return
    ExerciseContext.pitch_range[0] += 1
    var start := Note.new(ExerciseContext.pitch_range[0])
    start_label.set_text(str(start))
    range_changed.emit()

func _on_start_down_pressed():
    ExerciseContext.pitch_range[0] -= 1
    var start := Note.new(ExerciseContext.pitch_range[0])
    start_label.set_text(str(start))
    range_changed.emit()

func _on_end_up_pressed():
    ExerciseContext.pitch_range[1] += 1
    var end := Note.new(ExerciseContext.pitch_range[1])
    end_label.set_text(str(end))
    range_changed.emit()

func _on_end_down_pressed():
    if ExerciseContext.pitch_range[1] - 1 <= ExerciseContext.pitch_range[0]:
        return
    ExerciseContext.pitch_range[1] -= 1
    var end := Note.new(ExerciseContext.pitch_range[1])
    end_label.set_text(str(end))
    range_changed.emit()
