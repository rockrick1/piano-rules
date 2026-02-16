extends Control

@onready var Note : PackedScene = load("res://Scenes/Objects/Note.tscn")

@onready var InputReader : Node
@onready var NoteGroup : Node
@onready var OptionsPanel : Node
@onready var Assist : Node
@onready var HardAssist : Node
@onready var Complements : Node

var note_range_open : bool = false

var assist_mode : bool = false
var hard_assist_mode : bool = false
var pitch_range = [60,87]
var any_octave : bool = false
var accidentals : bool = true

var combo : int = 0
var max_combo : int = 0

var tone_offset : float

var current_ex

func _ready():
	# generate a new random seed
	randomize()
	
	# input reading scene
	InputReader = $InputReader
	
	# parent node for all the notes on screen
	NoteGroup = $MarginContainer/MarginContainer/TextureRect/Notes
	
	# options panel, with many settings
	OptionsPanel = $MarginContainer/Buttons/Configs/OptionsPanel
	OptionsPanel.EC = self
	
	# Assist nodes
	Assist = $MarginContainer/MarginContainer/TextureRect/Assist
	HardAssist = $MarginContainer/MarginContainer/TextureRect/HardAssist
	Complements = $MarginContainer/MarginContainer/TextureRect/Complements
	Assist.visible = false
	HardAssist.visible = false
	Complements.get_node("TopLine").hide()
	Complements.get_node("BotLine").hide()
	
	
	tone_offset = $MarginContainer/MarginContainer/TextureRect/Anchor77.position.y - $MarginContainer/MarginContainer/TextureRect/Anchor60.position.y
	tone_offset /= 10
	
	print(tone_offset)
	load_exercise("RandomNote")

func _process(_delta):
	# process note hits from input
	for note in NoteGroup.get_children():
		# doesn't consider notes that are on screen but have already been played
		# only considers one not, for now
		if (not note.alive) or len(get_just_pressed_keys()) == 0:
			continue
		var pitch = get_just_pressed_keys()[0]
		var note_str = NoteMapping.notes[note.pitch]
		var input_note_str = NoteMapping.notes[pitch]
		# hit!
		if note.pitch == pitch or (any_octave && note_str.substr(1) == input_note_str.substr(1)):
			print("you got it bro!")
			note.hit()
			_set_combo(combo + 1)
			current_ex.next_step()
		# wrong note pressed :(
		else:
			print("man, u suck...")
			note.miss()
			_set_combo(0)
	InputReader.just_pressed.clear()
	InputReader.just_released.clear()

func load_exercise(ex_name):
	print(">>>loading exercise: " + ex_name)
	var exercise_script = load("res://Scripts/Exercises/" + ex_name + ".gd")
	current_ex = exercise_script.new(self)

func get_note_position_by_name(note_str) -> Vector2:
	var octave = int(note_str[0])
	var full_note = note_str.substr(1)
	var note = note_str[1]
	var note_offset = NoteMapping.offsets[note]
	var octave_offset = tone_offset * 7
	var dist = (note_offset * tone_offset) + ((octave - 6) * octave_offset)
	var pos = $MarginContainer/MarginContainer/TextureRect/Anchor60.position + Vector2(((note_offset + octave) % 2) * -50, dist)
	return pos

func add_note(pitch):
	# pitch 60 = 6C
	var note = Note.instantiate()
	var note_str = NoteMapping.notes[pitch]
	note.position = get_note_position_by_name(note_str)
	note.pitch = pitch
	note.note_str = note_str
	var full_note = note_str.substr(1)
	if "#" in full_note:
		note.sharp()
	elif "b" in full_note:
		note.flat()
	$MarginContainer/MarginContainer/TextureRect/Notes.add_child(note)
	print("add note in pitch "+str(pitch))

# murders all notes on screen
func kill_all_notes():
	for note in NoteGroup.get_children():
		note.die()

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
	kill_all_notes()
	current_ex.next_step()


func _on_Configs_pressed():
	OptionsPanel.visible = not OptionsPanel.visible
#	$OptionsPanel.popup()

func _set_combo(combo):
	self.combo = combo
	max_combo = max(max_combo, combo)
	$MarginContainer/Buttons/Combos/Combo.set_text("Combo: "+str(combo))
	$MarginContainer/Buttons/Combos/MaxCombo.set_text("Max: "+str(max_combo))
