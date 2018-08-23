extends Node

# Class for displaying a neural networks topology.
# First (dummy) layer set by editor
#export var layers : UINeuralNetworkLayerPanel[] = []
export var layers = []

# Displays the given neural network.
#func display(neural_network : NeuralNetwork) -> void :
func display(neural_network) :
	var dummyLayer = load("res://scripts/gui/UINeuralNetworkLayerPanel.gd")
	
	layers.clear()
	# Duplicate layers
	for i in range(neural_network.layers.size()) :
		var panel = dummyLayer.new()
		self.add_child(panel)
		layers.append(panel)
	
	# Set layer contents
	for i in range(layers.size()) :
		layers[i].display(neural_network.layers[i])
	
	layers[layers.size() - 1].display(neural_network.layers[neural_network.layers.size() - 1].output_count)
	draw_connections(neural_network)

# Draw the connections (coroutine).
#func draw_connections(neural_network : NeuralNetwork) -> IEnumerator :
func draw_connections(neural_network) :
	yield(get_tree(), "physics_frame")
	
	# Draw node connections
	for i in range(layers.size()) :
		layers[i].display_connections(neural_network.layers[i], layers[i + 1])
	
	layers[layers.size() - 1].hide_all_connections()