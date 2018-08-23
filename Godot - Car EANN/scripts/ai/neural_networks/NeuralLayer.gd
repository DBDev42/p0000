extends Node

# Class representing a single layer of a fully connected feedforward neural network.

# The activation function used by the neurons of this layer.
# The default activation function is the sigmoid function (see <see cref="MathHelper.SigmoidFunction(double)"/>).
var neuron_activation_function = funcref(MathHelper, "sigmoid_function")

# The amount of neurons in this layer.
#var neuron_count : int setget , get_neuron_count
var neuron_count setget , get_neuron_count

func get_neuron_count() :
	return neuron_count

# The amount of neurons this layer is connected to, i.e., the amount of neurons of the next layer.
#var output_count setget , get_neuron_count
var output_count setget , get_output_count

func get_output_count() :
	return output_count

# The weights of the connections of this layer to the next layer.
# E.g., weight [i, j] is the weight of the connection from the i-th weight
# of this layer to the j-th weight of the next layer.
#var weights : float[][] setget , get_weights
var weights setget , get_weights

func get_weights() :
	return weights

# Initialises a new neural layer for a fully connected feedforward neural network with given 
# amount of node and with connections to the given amount of nodes of the next layer.
# All weights of the connections from this layer to the next are initialised with the default double value.
#func _init(p_neuron_count : int, p_output_count : int)
func _init(p_neuron_count, p_output_count) :
	neuron_count = p_neuron_count
	output_count = p_output_count
	
	weights = []
	for i in range(neuron_count) :
		weights.append([])
		for j in range(output_count) :
			weights[i].append(0)
		pass
	pass

# Sets the weights of this layer to the given values.
# The values are ordered in neuron order. E.g., in a layer with two neurons with a next layer of three neurons 
# the values [0-2] are the weights from neuron 0 of this layer to neurons 0-2 of the next layer respectively and 
# the values [3-5] are the weights from neuron 1 of this layer to neurons 0-2 of the next layer respectively.
#func set_weights(p_weights : float[]) -> void
func set_weights(p_weights) :
	if p_weights.size() == (neuron_count * output_count) :
		var k = 0
		for outputs in weights :
			for weight in outputs :
				weight = p_weights[k]
				k += 1
			pass
		pass
	else :
		print("Input weights do not match layer weight count.")

# Processes the given inputs using the current weights to the next layer.
#func process_inputs(p_inputs float[]) -> float[] :
func process_inputs(p_inputs) :
	if p_inputs.size() == neuron_count :
		# Add bias (always on) neuron to inputs
		var biased_inputs = p_inputs.duplicate()
		biased_inputs.append(1.0)
		
		# Calculate sum for each neuron from weighted inputs and bias
		var sums = []
		sums.resize(output_count)
		for i in range(sums.size()) :
			sums[i] = 0
		
		for j in range(weights[1].size()) :
			for i in range(weights[0].size()) :
				sums[j] += biased_inputs[i] * weights[i][j]
		
		# Apply activation function to sum, if set
		if neuron_activation_function != null :
			for sum in sums :
				sum = neuron_activation_function.call_func(sum)
		
		return sums
	else :
		print("Given xValues do not match layer input count.")

#
#/// <summary>
#/// Copies this NeuralLayer including its weights.
#/// </summary>
#/// <returns>A deep copy of this NeuralLayer</returns>
#public NeuralLayer DeepCopy()
#{
#    //Copy weights
#    double[,] copiedWeights = new double[this.Weights.GetLength(0), this.Weights.GetLength(1)];
#
#    for (int x = 0; x < this.Weights.GetLength(0); x++)
#        for (int y = 0; y < this.Weights.GetLength(1); y++)
#            copiedWeights[x, y] = this.Weights[x, y];
#
#    //Create copy
#    NeuralLayer newLayer = new NeuralLayer(this.NeuronCount, this.OutputCount);
#    newLayer.Weights = copiedWeights;
#    newLayer.NeuronActivationFunction = this.NeuronActivationFunction;
#
#    return newLayer;
#}
#
# Sets the weights of the connection from this layer to the next to random values in given range.
#func set_random_weights(p_min_value : float, p_max_value : float) -> void :
func set_random_weights(p_min_value, p_max_value) :
	var diff = p_max_value - p_min_value
	for i in range(weights[0].size()) :
		for j in range(weights[1].size()) :
			weights[i][j] = p_min_value + diff * randf()

#
#/// <summary>
#/// Returns a string representing this layer's connection weights.
#/// </summary>
#public override string ToString()
#{
#    string output = "";
#
#    for (int x = 0; x < Weights.GetLength(0); x++)
#    {
#        for (int y = 0; y < Weights.GetLength(1); y++)
#            output += "[" + x + "," + y + "]: " + Weights[x, y];
#
#        output += "\n";
#    }
#
#    return output;
#}
##endregion
#}