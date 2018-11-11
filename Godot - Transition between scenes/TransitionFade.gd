extends Node

signal finished(transition)

const SIGNAL_FINISHED = "finished"

func fade_out():
	$Layer/Transitions.play("FadeOut")

func fade_in():
	$Layer/Transitions.play("FadeIn")

func _on_Fade_animation_finished(anim_name):
	emit_signal(SIGNAL_FINISHED, anim_name)
