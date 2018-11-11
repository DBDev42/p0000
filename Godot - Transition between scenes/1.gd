extends Node

const SCENE_2 = preload("res://2.tscn")

func _on_ChangeTo_button_up():
	StateMachine.change_scene(SCENE_2.instance())
