class_name Signatures
extends OptionsSubPanel

@export var grid_container : GridContainer
@export var button_scene : PackedScene

func _ready() -> void:
    _create_buttons()

func _create_buttons():
    for scale in Scale.Type.values():
        if scale == Scale.Type.ANY:
            continue
        
        for accidental in Note.Accidental.values():
            for letter in Note.Letter.values():
                _create_button(scale, accidental, letter)

func _create_button(scale: Scale.Type, accidental: Note.Accidental, letter: Note.Letter):
    var button_instance : Button = button_scene.instantiate()
    grid_container.add_child(button_instance)
    button_instance.pressed.connect(func():
        _on_button_pressed(scale, accidental, letter)
    )
    button_instance.text = Scale.get_scale_string(scale, accidental, letter)

func _on_button_pressed(scale: Scale.Type, accidental: Note.Accidental, letter: Note.Letter):
    ExerciseContext.scale_type = scale
    ExerciseContext.scale_accidental = accidental
    ExerciseContext.scale_letter = letter
