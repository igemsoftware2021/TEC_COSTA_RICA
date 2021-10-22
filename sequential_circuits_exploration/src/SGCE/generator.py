from SGCE.circuit import *
from itertools import permutations, product, chain, islice
import math

# TODO Generate circuits in order


def randomizeCircuit(circuit: GeneticCircuit, n_orientation: int, n_order: int):
    hash_set = set()
    results = []
    seq_len = len(circuit.sequences)

    for i in range(n_orientation):
        randomized_sequences = circuit.sequences.copy()
        random.shuffle(randomized_sequences)
        n = random.randint(0, seq_len)
        randomized_sequences[0:n] = list(map(flipSequenceOrientation,
                                             randomized_sequences[0:n]))
        for j in range(n_order):
            random.shuffle(randomized_sequences)
            new_cir = replace(circuit, sequences=randomized_sequences.copy())
            resetGeneticCircuit(new_cir)
            # if(new_cir.hash not in hash_set):
            results.append(new_cir)
            # hash_set.add(new_cir.hash)

    return results


def circuitOrderPermutations(circuit: GeneticCircuit):
    cir_list = map(lambda x: updateGeneticCircuitSequences(
        circuit=circuit, sequences=x), permutations(circuit.sequences))
    return cir_list


def circuitOrientationPermutations(circuit: GeneticCircuit):
    ori_list = product([FORWARD, REVERSE], repeat=len(circuit.sequences))
    seq_list = []
    for ori in ori_list:
        seq_list.append(map(lambda seq, ori: replace(
            seq, orientation=ori), circuit.sequences, ori))
    cir_list = map(lambda x: updateGeneticCircuitSequences(
        circuit=circuit, sequences=list(x)), seq_list)
    return cir_list


def circuitPermutations(circuit: GeneticCircuit):
    cir_ori_list = circuitOrientationPermutations(circuit)
    cir_list = chain.from_iterable(
        map(circuitOrderPermutations, cir_ori_list))
    return cir_list


def calculateTotalPermutations(circuit: GeneticCircuit):
    s_len = len(circuit.sequences)
    return pow(2, s_len)*math.factorial(s_len)
