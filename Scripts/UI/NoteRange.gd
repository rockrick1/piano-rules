class_name NoteRange
extends AcceptDialog

@export var start_label : Control
@export var end_label : Control

var pitch_range : Array
var exercise_controller : ExerciseController

func init(controller):
    exercise_controller = controller
    pitch_range = exercise_controller.pitch_range
    var start := Note.new(pitch_range[0])
    var end := Note.new(pitch_range[1])
    start_label.set_text(str(start))
    end_label.set_text(str(end))
    
    _set_line_pos("Top", start)
    _set_line_pos("Bot", end)
    exercise_controller.complements.get_node("TopLine").show()
    exercise_controller.complements.get_node("BotLine").show()

func _on_Start_Up_pressed():
    if pitch_range[0] + 1 >= pitch_range[1]:
        return
    pitch_range[0] = pitch_range[0] + 1
    var start := Note.new(pitch_range[0])
    start_label.set_text(str(start))
    _set_line_pos("Top", start)

func _on_Start_Down_pressed():
    pitch_range[0] = pitch_range[0] - 1
    var start := Note.new(pitch_range[0])
    start_label.set_text(str(start))
    _set_line_pos("Top", start)

func _on_End_Up_pressed():
    pitch_range[1] = pitch_range[1] + 1
    var end := Note.new(pitch_range[1])
    end_label.set_text(str(end))
    _set_line_pos("Bot", end)

func _on_End_Down_pressed():
    if pitch_range[1] - 1 <= pitch_range[0]:
        return
    pitch_range[1] = pitch_range[1] - 1
    var end := Note.new(pitch_range[1])
    end_label.set_text(str(end))
    _set_line_pos("Bot", end)

func _set_line_pos(line, note : Note):
    var pos := Vector2(1024/2, exercise_controller.get_note_position(note).y)
    exercise_controller.complements.get_node(line+"Line").set_position(pos)

func _on_Control_confirmed():
    exercise_controller.note_range_open = false
    exercise_controller.complements.get_node("TopLine").hide()
    exercise_controller.complements.get_node("BotLine").hide()
    queue_free()
