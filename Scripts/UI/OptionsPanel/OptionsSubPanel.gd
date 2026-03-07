class_name OptionsSubPanel
extends Control

signal enabled
signal disabled

func enable():
    show()
    enabled.emit()
    
func disable():
    hide()
    disabled.emit()
