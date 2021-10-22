from .constants import *
from .sequences import *
import random
import copy
from SGCE.dataclasses_utils import *


random.seed()


# Sequence:
#  [sequience_id, direction, group_id ]
@dataclass
class GeneticCircuit():
    hash: int = 0
    # unique_sequences: set = field(default_factory=set)  # set
    sequences: list = field(default_factory=list[Sequence])
    sequencesGroups: dict = field(default_factory=dict)  # sg:[id1, id2]
    expresing: list = field(default_factory=list)  # {id:[index1, index2]}
    previous_states: list = field(default_factory=list)  # list of hashes
    next_states: list = field(default_factory=list)  # list of hashes
    invalid: bool = False
    validated: bool = False
    actuated: bool = False

    def __hash__(self):
        self.hash = hash(tuple(map(astuple, self.sequences)))
        return self.hash


def generateCircuit(seqGrupsList) -> GeneticCircuit:
    circuit = GeneticCircuit()
    for i, seqGroup in enumerate(seqGrupsList):
        sequences = list(map(createSequence, seqGroup.sequences,
                         [i]*len(seqGroup.sequences)))
        circuit.sequences = circuit.sequences+sequences
        # circuit.unique_sequences = circuit.unique_sequences.union(
        #     seqGroup.sequences)

        if seqGroup.id in circuit.sequencesGroups:
            circuit.sequencesGroups[seqGroup.name].append(i)
        else:
            circuit.sequencesGroups[seqGroup.name] = [i]
    hash(circuit)
    return circuit

    # def generateRandomCircuits(seqGrupsList, n=1) -> list:
    #     baseCircuit = generateCircuit(seqGrupsList)
    #     results = []
    #     for i in range(n):
    #         newCircuit = GeneticCircuit()
    #         newCircuit.sequencesGroups = copy.deepcopy(baseCircuit.sequencesGroups)
    #         newCircuit.sequences = copy.deepcopy(baseCircuit.sequences)
    #         random.shuffle(newCircuit.sequences)
    #         seq_len = len(newCircuit.sequences)
    #         n = random.randint(0, seq_len)
    #         directionList = [Direction.FORWARD]*n + [Direction.REVERSE]*(seq_len-n)
    #         random.shuffle(directionList)
    #         newCircuit.sequences = list(
    #             map(lambda s, d: setDirection(s, d), newCircuit.sequences,
    #                 directionList))
    #         results.append(newCircuit)
    #     return results


def promoterValidator(circuit: GeneticCircuit):
    circuit.expresing = []
    # promoter_indexes = ((i, item.orientation) for i, item in enumerate(
    #     circuit.sequences) if item.id == PROMOTER.id)
    # lenght = len(circuit.sequences)
    # for (i, ori) in promoter_indexes:
    #     index = i
    #     while(i>=0 and i <=lenght):
    seq_iterator = enumerate(circuit.sequences)
    results = {}
    results = promoterValidator_aux(seq_iterator, FORWARD, results=results)
    results = promoterValidator_aux(
        reversed(list(seq_iterator)), REVERSE, results=results)
    # print(results)
    # print(results)

    for key in results.keys():
        circuit.expresing = [*circuit.expresing, *results[key]]
    # print(results)
    # print(circuit.expresing)
    # circuit.expresing = [x for [x] in results.values()]
    circuit.validated = True


def promoterValidator_aux(seq_iterator, orientation, results={}):
    current_promoters = []
    for i, seq in seq_iterator:
        if(seq.orientation == orientation):
            if(seq.expresable and current_promoters):
                if (seq.id in results):
                    results[seq.id].append(
                        {"index": i,
                         "promoters": current_promoters,
                         "id": seq.id})
                else:
                    results[seq.id] = [
                        {"index": i,
                         "promoters": current_promoters,
                         "id": seq.id}]
            elif(seq.id == PROMOTER.id):
                current_promoters.append(i)
            elif(seq.id == TERMINATOR.id):
                current_promoters.clear()
        # elif(seq.orientation == BIDIRECTIONAL):
        #     if seq.id in results:
        #         if i in results[seq.id]:
        #             results[seq.id][i].extend(current_promoters)
        #         else:
        #             results[seq.id] = {i: current_promoters}
        #     else:
        #         results[(seq.id, i)] = current_promoters

    return results


def actuator(circuit: GeneticCircuit, actuatorfunctions={}):
    new_circuits = []
    for expresion_item in circuit.expresing:
        if expresion_item["id"] in actuatorfunctions:
            circuit.actuated = True
            selected_actuator = actuatorfunctions[expresion_item["id"]]
            temp_results = selected_actuator(circuit, expresion_item["index"])
            if temp_results:
                new_circuits = [*new_circuits, temp_results[0]]
    return new_circuits


def updateGeneticCircuitSequences(circuit: GeneticCircuit, sequences: list):
    new_cir = replace(circuit, sequences=sequences,
                      expresing=list(), previous_states=[])
    hash(new_cir)
    return new_cir


def resetGeneticCircuit(circuit: GeneticCircuit):
    circuit.validated = False
    circuit.actuated = False
    circuit.validated = False
    circuit.expresing = dict()
    hash(circuit)
    circuit.previous_states = []


def dict_to_circuit(circuit_dict: dict):
    sequences = []
    dict_sequences = circuit_dict.pop("sequences")
    for sequence_dict in dict_sequences:
        sequences.append(dict_to_sequence(sequence_dict))

    result_circuit = dataclass_from_dict(GeneticCircuit, circuit_dict)
    result_circuit.sequences = sequences
    return result_circuit
