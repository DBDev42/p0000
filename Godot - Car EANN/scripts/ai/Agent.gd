extends Node

# Class that combines a genotype and a feedforward neural network (FNN).

# The underlying genotype of this agent.
#var genotype : Genotype setget , get_genotype
var genotype setget , get_genotype

func get_genotype() :
	return genotype

# The feedforward neural network which was constructed from the genotype of this agent.
#var fnn : NeuralNetwork setget , get_fnn
var fnn setget , get_fnn

func get_fnn() :
	return fnn

# Whether this agent is currently alive (actively participating in the simulation).
#var is_alive : bool = false setget set_is_alive, get_is_alive
var is_alive = false setget set_is_alive, get_is_alive

func get_is_alive() :
	return is_alive

func set_is_alive(p_is_alive) :
	if is_alive != p_is_alive :
		is_alive = p_is_alive
		if not is_alive :
			emit_signal("agent_died")

# Event for when the agent died (stopped participating in the simulation).
signal agent_died
const SIGNAL_AGENT_DIED = "agent_died"

# Initialises a new agent from given genotype, constructing a new feedfoward neural network from
# the parameters of the genotype.
#func _init(p_genotype : Genotype, p_default_activation : NeuralLayer.ActivationFunction, p_topology: []) -> void :
func _init(p_genotype, p_default_activation, p_topology) :
	is_alive = false
	genotype = p_genotype
	fnn = load("res://scripts/ai/neural_networks/NeuralNetwork.gd").new(p_topology)
#	for l in fnn.layers :
#		l.neuron_activation_function = p_default_activation
	
	# Check if topology is valid
	if fnn.weight_count != genotype.parameter_count :
		print("The given genotype's parameter count must match the neural network topology's weight count.")
	
	# Construct FNN from genotype
	var k = 0
	for layer in fnn.layers :
		for i in range(layer.weights[0].size()) :
			for j in range(layer.weights[1].size()) :
				layer.weights[i][j] = genotype.parameters[k]
				k += 1

# Resets this agent to be alive again.
#func reset() -> void :
func reset() :
	genotype.evaluation = 0
	genotype.fitness = 0
	is_alive = true

# Kills this agent (sets IsAlive to false).
#func kill() -> void :
func kill() :
	is_alive = false
	emit_signal(SIGNAL_AGENT_DIED)

# Compares this agent to another agent, by comparing their underlying genotypes.
#func compare_to(p_agent : Agent) -> bool :
func compare_to(p_agent) :
	return genotype.compare_to(p_agent.genotype)