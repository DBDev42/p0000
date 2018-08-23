extends Control

# Class for controlling the various ui elements of the simulation

# The Car to fill the GUI data with.
#var target : CarController setget set_target, get_target
var target setget set_target, get_target

func set_target(p_target) :
	if target != p_target :
		target = p_target
		if target != null :
			$UINeuralNetworkPanel.display(target.agent.fnn)

func get_target() :
	return target
	

func _on_ready() :
	set_process(true)

func _process(delta):
	if target != null :
		# Display controls
		if target.current_control_inputs != null :
			$Inputs/Turn/Value.text = str(target.current_control_inputs[0])
			$Inputs/Engine/Value.text = str(target.current_control_inputs[1])
		
		# Display evaluation and generation count
		$Inputs/Eval/Value.text = str(target.agent.genotype.evaluation)
		$Generation/Value.text = str(EvolutionManager.generation_count)

# Starts to display the gui elements.
#func show() -> void :
func show() :
	self.show()

# Stops displaying the gui elements.
#func hide() -> void :
func hide() :
	self.hide()