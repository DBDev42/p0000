extends Node

const SCENE_1 = preload("res://1.tscn")

func _ready():
	StateMachine.transitions_node = $Transition
	StateMachine.scenes_node = $Scenes
	StateMachine.change_scene(SCENE_1.instance())
