class_name NoteRange
extends AcceptDialog

var pitch_range : Array
var ExerciseController : Node

var start_label : Control
var end_label : Control

func init(controller):
    ExerciseController = controller
    pitch_range = ExerciseController.pitch_range
    start_label = $Buttons/Start/Label
    end_label = $Buttons/End/Label
    var start = NoteMapping.notes[pitch_range[0]]
    var end = NoteMapping.notes[pitch_range[1]]
    start_label.set_text(start)
    end_label.set_text(end)
    
    _set_line_pos("Top", start)
    _set_line_pos("Bot", end)
    ExerciseController.Complements.get_node("TopLine").show()
    ExerciseController.Complements.get_node("BotLine").show()


func _on_Start_Up_pressed():
    if pitch_range[0] + 1 >= pitch_range[1]:
        return
    pitch_range[0] = pitch_range[0] + 1
    var start = NoteMapping.notes[pitch_range[0]]
    start_label.set_text(start)
    _set_line_pos("Top", start)


func _on_Start_Down_pressed():
    pitch_range[0] = pitch_range[0] - 1
    var start = NoteMapping.notes[pitch_range[0]]
    start_label.set_text(start)
    _set_line_pos("Top", start)


func _on_End_Up_pressed():
    pitch_range[1] = pitch_range[1] + 1
    var end = NoteMapping.notes[pitch_range[1]]
    end_label.set_text(end)
    _set_line_pos("Bot", end)


func _on_End_Down_pressed():
    if pitch_range[1] - 1 <= pitch_range[0]:
        return
    pitch_range[1] = pitch_range[1] - 1
    var end = NoteMapping.notes[pitch_range[1]]
    end_label.set_text(end)
    _set_line_pos("Bot", end)


func _set_line_pos(line, note_str):
    var pos = Vector2(1024/2, ExerciseController.get_note_position_by_name(note_str).y)
    ExerciseController.Complements.get_node(line+"Line").set_position(pos)


func _on_Control_confirmed():
    ExerciseController.note_range_open = false
    ExerciseController.Complements.get_node("TopLine").hide()
    ExerciseController.Complements.get_node("BotLine").hide()
    queue_free()
