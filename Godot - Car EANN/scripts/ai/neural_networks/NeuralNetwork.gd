extends Node

# Script representing a fully connceted feedforward neural network.

# The individual neural layers of this network.
#var layers : NeuralLayer[] setget , get_layers
var layers setget , get_layers

func get_layers() :
	return layers

# An array of unsigned integers representing the node count 
# of each layer of the network from input to output layer.
#var topology : int[] setget , get_topology
var topology setget , get_topology

func get_topology() :
	return topology

# The amount of overall weights of the connections of this network.
#var weight_count : int setget , get_weight_count
var weight_count setget , get_weight_count

func get_weight_count() :
	return weight_count

# Initialises a new fully connected feedforward neural network with given topology.
#func _init(p_topology : int[]) -> void :
func _init(p_topology) :
	topology = p_topology
	
	# Calculate overall weight count
	weight_count = 0

	for i in range(topology.size() - 1) :
		weight_count += (topology[i] + 1) * topology[i + 1] # +1 for bias node
	pass
	
	# Initialise layers
	layers = []
	for i in range(topology.size() - 1) :
		layers.append(load("res://scripts/ai/neural_networks/NeuralLayer.gd").new(topology[i], topology[i + 1]))

# Processes the given inputs using the current network's weights.
#func process_inputs(p_inputs : float[]) -> float[] :
func process_inputs(p_inputs) :
	if p_inputs.size() == layers[0].neuron_count :
		var outputs = p_inputs
		for layer in layers :
			outputs = layer.process_inputs(outputs)
		
		return outputs
	else :
		print("Given inputs do not match network input amount.")

# Sets the weights of this network to random values in given range.
#func set_random_weights(p_min_value : float, p_max_value : float) -> void :
func set_random_weights(p_min_value, p_max_value) :
	if layers != null :
		for layer in layers :
			layer.set_random_weights(p_min_value, p_max_value)
#
#/// <summary>
#/// Returns a new NeuralNetwork instance with the same topology and 
#/// activation functions, but the weights set to their default value.
#/// </summary>
#public NeuralNetwork GetTopologyCopy()
#{
#    NeuralNetwork copy = new NeuralNetwork(this.Topology);
#    for (int i = 0; i < Layers.Length; i++)
#        copy.Layers[i].NeuronActivationFunction = this.Layers[i].NeuronActivationFunction;
#
#    return copy;
#}
#
#/// <summary>
#/// Copies this NeuralNetwork including its topology and weights.
#/// </summary>
#/// <returns>A deep copy of this NeuralNetwork</returns>
#public NeuralNetwork DeepCopy()
#{
#    NeuralNetwork newNet = new NeuralNetwork(this.Topology);
#    for (int i = 0; i < this.Layers.Length; i++)
#        newNet.Layers[i] = this.Layers[i].DeepCopy();
#
#    return newNet;
#}
#
#/// <summary>
#/// Returns a string representing this network in layer order.
#/// </summary>
#public override string ToString()
#{
#    string output = "";
#
#    for (int i = 0; i<Layers.Length; i++)
#        output += "Layer " + i + ":\n" + Layers[i].ToString();
#
#    return output;
#}
##endregion
#}