extends Control

onready var NoteMapping = load("res://Scripts/NoteMapping.gd")
onready var BaseExercise = load("res://Exercises/Exercise.gd")
onready var Note = load("res://Objects/Note.tscn")

onready var InputReader : Node
onready var NoteGroup : Node
onready var OptionsPanel : Node

var tone_offset : float

var current_ex

func _ready():
	# generate a new random seed
	randomize()
	InputReader = $InputReader
	NoteGroup = $VSplitContainer/MarginContainer/TextureRect/Notes
	OptionsPanel = $VSplitContainer/OptionsPanel
	tone_offset = $VSplitContainer/MarginContainer/TextureRect/Anchor77.position.y - $VSplitContainer/MarginContainer/TextureRect/Anchor60.position.y
	tone_offset /= 10
	print(tone_offset)
	_add_config_options()
	load_exercise("RandomNote")

func _process(_delta):
	for note in NoteGroup.get_children():
		for pitch in get_just_pressed_keys():
			# hit!
			if note.pitch == pitch:
				print("you got it bro!")
				current_ex.next_step()
			else:
				print("man, u suck...")
				break

func load_exercise(ex_name):
	print("loading exercise " + ex_name)
	var exercise_script = load("res://Exercises/" + ex_name + ".gd")
	current_ex = exercise_script.new(self)

func get_note_position_by_name(note_str) -> Vector2:
	var octave = int(note_str[0])
	var full_note = note_str.substr(1)
	var note = note_str[1]
	print(octave, " - ", full_note)
	var note_offset = NoteMapping.get_offsets()[note]
	
	var octave_offset = tone_offset * 7
	
	var dist = (note_offset * tone_offset) + ((octave - 6) * octave_offset)
	var pos = $VSplitContainer/MarginContainer/TextureRect/Anchor60.position + Vector2((note_offset % 2) * -50, dist)
	return pos

func add_note(pitch):
	# pitch 60 = 6C
	var note = Note.instance()
	var note_str = NoteMapping.get_map()[pitch]
	note.position = get_note_position_by_name(note_str)
	note.pitch = pitch
	note.note_str = note_str
	var full_note = note_str.substr(1)
	if "#" in full_note:
		note.sharp()
	$VSplitContainer/MarginContainer/TextureRect/Notes.add_child(note)
	print("add note in pitch "+str(pitch))

func kill_all_notes():
	for note in NoteGroup.get_children():
		note.queue_free()

func get_pressed_keys():
	return InputReader.currently_pressed.keys()

func get_just_pressed_keys():
	return InputReader.just_pressed.keys()

func get_just_released_keys():
	return InputReader.just_released.keys()

func is_key_pressed(pitch):
	return InputReader.currently_pressed.has(pitch)

func is_key_just_pressed(pitch):
	return InputReader.just_pressed.has(pitch)

func is_key_just_released(pitch):
	return InputReader.just_released.has(pitch)


func _on_NextStep_pressed():
	current_ex.next_step()


func _on_Configs_pressed():
	OptionsPanel.visible = not OptionsPanel.visible
#	$OptionsPanel.popup()

func _add_config_options():
	OptionsPanel.add_check_item("Assist mode")