extends Control

@export var slider : HSlider
@export var value_label : Label

func _ready() -> void:
    slider.value_changed.connect(_on_value_changed)

func _on_value_changed(value: float):
    value_label.text = str(int(value))
