extends Node
# Singleton class for managing the evolutionary processes.


# Signals


# Constants
const _EVOLUTION_SECTION = "evolution"
const _EVOLUTION_MUTATION_RATE = "mutation_rate"
const _EVOLUTION_MUTATION_RATE_DEFAULT = 0.1


# Variables
var _first_predecessor = null
var _second_predecessor = null
var _mutation_rate = _EVOLUTION_MUTATION_RATE_DEFAULT

# Setters and Getters


# Constructors
func _init() :
	Logger.debug("Start func Evolution._init()")
	
	load_settings()
	
	Logger.debug("End fun Evolution._init")

# Process functions


# Other functions
func load_settings() :
	Logger.debug("Start func Evolution.load_settings()")
	
	_mutation_rate = Settings.get_setting(_EVOLUTION_SECTION, _EVOLUTION_MUTATION_RATE)
	if _mutation_rate == null :
		Logger.error("Car amount not found. Loading default car amount")
		_mutation_rate = _EVOLUTION_MUTATION_RATE_DEFAULT
		Settings.set_setting(_EVOLUTION_SECTION, _EVOLUTION_MUTATION_RATE, _EVOLUTION_MUTATION_RATE_DEFAULT)
	
	Logger.debug("End func Evolution.load_settings")

func car_died(p_car) :
	update_first_predecessor(p_car)

func car_rewarded(p_car) :
	update_first_predecessor(p_car)

func update_first_predecessor(p_car) :
	if p_car != null :
		if _first_predecessor != null :
			_second_predecessor = _first_predecessor
		_first_predecessor = p_car

func evolve(p_inputs_counts, p_outputs) :
	var result = null
	if _first_predecessor == null :
		result = Factory.build(Factory.NEURALNETWORK).random(p_inputs_counts, p_outputs)
	else :
		result = Factory.build(Factory.NEURALNETWORK).initialize(mutate(_first_predecessor.get_genotypes()))
	return result

func mutate(p_genotypes) :
	for genotype in p_genotypes.values() :
		if typeof(genotype) == TYPE_DICTIONARY:
			mutate(genotype)
		else :
			if genotype is Factory.GENOTYPE:
				if Utils.random_float() <= _mutation_rate :
					match genotype.get_type() :
						genotype.CONTINOUS_TYPE :
							genotype.set_value(Utils.random_float())
	return p_genotypes
## Whether or not the results of each generation shall be written to file, to be set in editor
##export var save_statistics : bool = false
#export var save_statistics = false;
##export var statistics_file_name : String = "statistics.txt"
#export var statistics_file_name = "statistics.txt"
#
## How many of the first to finish the course should be saved to file, to be set in editor
##export var save_first_genotype : int = 0
#export var save_first_genotype = 0
##export var genotypes_saved : int = 0
#export var genotypes_saved = 0
#
## Population size, to be set in editor
##export var population_size : int = 30
#export var population_size = 1
#
## After how many generations should the genetic algorithm be restart (0 for never), to be set in editor
##export var restart_after : int = 100
#export var restart_after = 100
#
## Whether to use elitist selection or remainder stochastic sampling, to be set in editor
##export var elitist_selection : bool = false
#export var elitist_selection = false
#
## Topology of the agent's FNN, to be set in editor
##export var fnn_topology : int[] = []
#export var fnn_topology = [5, 4, 3, 2]
#
## The current population of agents.
##var agents : Agent[] = []
#var agents = []
#
## The amount of agents that are currently alive.
##var agents_alive_count : int
#var agents_alive_count
#
## Signal for when all agents have died.
#signal all_agents_died
#const SIGNAL_ALL_AGENTS_DIED = "all_agents_died"
#
##var genetic_algorithm : GeneticAlgorithm
#var genetic_algorithm
#
## The age of the current generation.
##var generation_count : int setget , get_generation_count
#var generation_count setget , get_generation_count
#
#func get_generation_count() :
#	return genetic_algorithm.generation_count
#
#var track_manager
#
## Starts the evolutionary process.
##func start_evolution() -> void :
#func start_evolution() :
#	# Create neural network to determine parameter count
#	var nn = load("res://scripts/ai/neural_networks/NeuralNetwork.gd").new(fnn_topology)
#
#	# Setup genetic algorithm
#	genetic_algorithm = load("res://scripts/ai/evolution/GeneticAlgorithm.gd").new(nn.weight_count, population_size)
#	genotypes_saved = 0
#
#	genetic_algorithm.evaluation = funcref(EvolutionManager, "start_evaluation")
#
#	if (elitist_selection) :
#		# Second configuration
#		genetic_algorithm.selection = genetic_algorithm.DefaultSelectionOperator
#		genetic_algorithm.recombination = "EvolutionManager.random_recombination"
#		genetic_algorithm.mutation = "EvolutionManager.mutate_all_but_best_two"
#	else :
#		#First configuration
#		genetic_algorithm.selection = "EvolutionManager.remainder_stochastic_sampling"
#		genetic_algorithm.recombination = "EvolutionManager.random_recombination"
#		genetic_algorithm.mutation = "EvolutionManager.mutate_all_but_best_two"
#
#	self.connect(EvolutionManager.SIGNAL_ALL_AGENTS_DIED, genetic_algorithm, "evaluation_finished")
#
#	# Statistics
##	if (save_statistics) :
##		statistics_file_name = "Evaluation.txt"
##		WriteStatisticsFileStart()
##		geneticAlgorithm.FitnessCalculationFinished += WriteStatisticsToFile
#	genetic_algorithm.connect(genetic_algorithm.SIGNAL_FITNESS_CALCULATION_FINISHED, self, "check_for_track_finished")
##
##	# Restart logic
##	if (RestartAfter > 0) : 
##		geneticAlgorithm.TerminationCriterion += CheckGenerationTermination
##		geneticAlgorithm.AlgorithmTerminated += OnGATermination
#	genetic_algorithm.start();
#
##
##// Writes the starting line to the statistics file, stating all genetic algorithm parameters.
##private void WriteStatisticsFileStart()
##{
##    File.WriteAllText(statisticsFileName + ".txt", "Evaluation of a Population with size " + PopulationSize + 
##            ", on Track \"" + GameStateManager.Instance.TrackName + "\", using the following GA operators: " + Environment.NewLine +
##            "Selection: " + geneticAlgorithm.Selection.Method.Name + Environment.NewLine +
##            "Recombination: " + geneticAlgorithm.Recombination.Method.Name + Environment.NewLine +
##            "Mutation: " + geneticAlgorithm.Mutation.Method.Name + Environment.NewLine + 
##            "FitnessCalculation: " + geneticAlgorithm.FitnessCalculationMethod.Method.Name + Environment.NewLine + Environment.NewLine);
##}
##
##// Appends the current generation count and the evaluation of the best genotype to the statistics file.
##private void WriteStatisticsToFile(IEnumerable<Genotype> currentPopulation)
##{
##    foreach (Genotype genotype in currentPopulation)
##    {
##        File.AppendAllText(statisticsFileName + ".txt", geneticAlgorithm.GenerationCount + "\t" + genotype.Evaluation + Environment.NewLine);
##        break; //Only write first
##    }
##}
#
## Checks the current population and saves genotypes to a file if their evaluation is greater than or equal to 1
##func check_for_track_finished(p_population : Genotype[]) -> void :
#func check_for_track_finished(p_population) :
#	print("check_for_track_finished")
##private void CheckForTrackFinished(IEnumerable<Genotype> currentPopulation)
##{
##    if (genotypesSaved >= SaveFirstNGenotype) return;
##
##    string saveFolder = statisticsFileName + "/";
##
##    foreach (Genotype genotype in currentPopulation)
##    {
##        if (genotype.Evaluation >= 1)
##        {
##            if (!Directory.Exists(saveFolder))
##                Directory.CreateDirectory(saveFolder);
##
##            genotype.SaveToFile(saveFolder + "Genotype - Finished as " + (++genotypesSaved) + ".txt");
##
##            if (genotypesSaved >= SaveFirstNGenotype) return;
##        }
##        else
##            return; //List should be sorted, so we can exit here
##    }
##}
##
##// Checks whether the termination criterion of generation count was met.
##private bool CheckGenerationTermination(IEnumerable<Genotype> currentPopulation)
##{
##    return geneticAlgorithm.GenerationCount >= RestartAfter;
##}
##
##// To be called when the genetic algorithm was terminated
##private void OnGATermination(GeneticAlgorithm ga)
##{
##    AllAgentsDied -= ga.EvaluationFinished;
##
##    RestartAlgorithm(5.0f);
##}
##
##// Restarts the algorithm after a specific wait time second wait
##private void RestartAlgorithm(float wait)
##{
##    Invoke("StartEvolution", wait);
##}
##
## Starts the evaluation by first creating new agents from the current population and then restarting the track manager.
##func start_evaluation(current_population : Genotype[]) -> void :
#func start_evaluation(p_current_population) :
#	# Create new agents from currentPopulation
#	agents.clear()
#	for g in p_current_population : 
#		agents.append(load("res://scripts/ai/Agent.gd").new(g, "softsignfunction", fnn_topology))
#
#	agents_alive_count = agents.size()
#
#	track_manager.set_car_amount(agents.size())
#
#	for i in range(agents.size()) :
#		track_manager.cars[i].car.agent = agents[i]
#		agents[i].connect(agents[i].SIGNAL_AGENT_DIED, self, "on_agent_died")
#	pass
#
#	track_manager.restart()
#
## Callback for when an agent died.
#func on_agent_died() :
#	agents_alive_count -= 1
#	if agents_alive_count == 0 :
#		emit_signal(SIGNAL_ALL_AGENTS_DIED)
#
##
###region GA Operators
##// Selection operator for the genetic algorithm, using a method called remainder stochastic sampling.
##private List<Genotype> RemainderStochasticSampling(List<Genotype> currentPopulation)
##{
##    List<Genotype> intermediatePopulation = new List<Genotype>();
##    //Put integer portion of genotypes into intermediatePopulation
##    //Assumes that currentPopulation is already sorted
##    foreach (Genotype genotype in currentPopulation)
##    {
##        if (genotype.Fitness < 1)
##            break;
##        else
##        {
##            for (int i = 0; i < (int) genotype.Fitness; i++)
##                intermediatePopulation.Add(new Genotype(genotype.GetParameterCopy()));
##        }
##    }
##
##    //Put remainder portion of genotypes into intermediatePopulation
##    foreach (Genotype genotype in currentPopulation)
##    {
##        float remainder = genotype.Fitness - (int)genotype.Fitness;
##        if (randomizer.NextDouble() < remainder)
##            intermediatePopulation.Add(new Genotype(genotype.GetParameterCopy()));
##    }
##
##    return intermediatePopulation;
##}
##
##// Recombination operator for the genetic algorithm, recombining random genotypes of the intermediate population
##private List<Genotype> RandomRecombination(List<Genotype> intermediatePopulation, uint newPopulationSize)
##{
##    //Check arguments
##    if (intermediatePopulation.Count < 2)
##        throw new System.ArgumentException("The intermediate population has to be at least of size 2 for this operator.");
##
##    List<Genotype> newPopulation = new List<Genotype>();
##    //Always add best two (unmodified)
##    newPopulation.Add(intermediatePopulation[0]);
##    newPopulation.Add(intermediatePopulation[1]);
##
##
##    while (newPopulation.Count < newPopulationSize)
##    {
##        //Get two random indices that are not the same
##        int randomIndex1 = randomizer.Next(0, intermediatePopulation.Count), randomIndex2;
##        do
##        {
##            randomIndex2 = randomizer.Next(0, intermediatePopulation.Count);
##        } while (randomIndex2 == randomIndex1);
##
##        Genotype offspring1, offspring2;
##        GeneticAlgorithm.CompleteCrossover(intermediatePopulation[randomIndex1], intermediatePopulation[randomIndex2], 
##            GeneticAlgorithm.DefCrossSwapProb, out offspring1, out offspring2);
##
##        newPopulation.Add(offspring1);
##        if (newPopulation.Count < newPopulationSize)
##            newPopulation.Add(offspring2);
##    }
##
##    return newPopulation;
##}
##
##// Mutates all members of the new population with the default probability, while leaving the first 2 genotypes in the list untouched.
##private void MutateAllButBestTwo(List<Genotype> newPopulation)
##{
##    for (int i = 2; i < newPopulation.Count; i++)
##    {
##        if (randomizer.NextDouble() < GeneticAlgorithm.DefMutationPerc)
##            GeneticAlgorithm.MutateGenotype(newPopulation[i], GeneticAlgorithm.DefMutationProb, GeneticAlgorithm.DefMutationAmount);
##    }
##}
##
##// Mutates all members of the new population with the default parameters
##private void MutateAll(List<Genotype> newPopulation)
##{
##    foreach (Genotype genotype in newPopulation)
##    {
##        if (randomizer.NextDouble() < GeneticAlgorithm.DefMutationPerc)
##            GeneticAlgorithm.MutateGenotype(genotype, GeneticAlgorithm.DefMutationProb, GeneticAlgorithm.DefMutationAmount);
##    }
##}
###endregion
###endregion
##
##}