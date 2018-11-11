extends Node

# Signals

# Enums

# Constants
const TRANSITIONS = preload("res://Transitions.tscn")

# Variables
var scenes_node = null
var transitions_node = null
var transitions = null
var previous_scene = false

# Setters and Getters

# Constructors

# Process functions

# Other functions

func change_scene(scene):
	if transitions == null:
		transitions = TRANSITIONS.instance()
	if previous_scene != null:
		transitions.fade_in()
		transitions_node.add_child(transitions)
		yield(transitions, transitions.SIGNAL_FINISHED)
		for child in scenes_node.get_children():
			scenes_node.remove_child(child)
			child.queue_free()
	scenes_node.add_child(scene)
	previous_scene = true
	transitions.fade_out()
	yield(transitions, transitions.SIGNAL_FINISHED)
	transitions_node.remove_child(transitions)