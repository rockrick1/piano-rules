extends Control

@export var note_range : NoteRange
@export var signatures : Signatures
@export var options_container : Control

var open_sub_panel : OptionsSubPanel

func _ready() -> void:
    hide()
    options_container.show()
    note_range.hide()
    signatures.hide()

func _on_close_pressed() -> void:
    if open_sub_panel != null:
        open_sub_panel.disable()
        open_sub_panel = null
        options_container.show()
        return
    
    hide()

func _on_background_button_pressed() -> void:
    if open_sub_panel != null:
        open_sub_panel.disable()
        open_sub_panel = null
        options_container.show()
        
    hide()

func _on_range_pressed() -> void:
    options_container.hide()
    note_range.enable()
    open_sub_panel = note_range

func _on_signatures_pressed() -> void:
    options_container.hide()
    signatures.enable()
    open_sub_panel = signatures

func _on_refresh_midi_pressed() -> void:
    OS.open_midi_inputs()

func _on_quit_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/Screens/MainMenu.tscn")
    # TODO this shouldnt be needed
    get_tree().root.get_node("ExerciseView").queue_free()
