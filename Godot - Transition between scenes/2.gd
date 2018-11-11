extends Node

const SCENE_1 = preload("res://1.tscn")

func _on_ChangeTo_button_up():
		StateMachine.change_scene(SCENE_1.instance())
