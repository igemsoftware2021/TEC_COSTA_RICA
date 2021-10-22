from SGCE.constants import *
from SGCE.sequences import *
from SGCE.circuit import *
from dataclasses import dataclass, field, replace, asdict, astuple


def actuator_tyrosine_recombinase(circuit: GeneticCircuit, seq_index: int):
    results = []
    group_id = circuit.sequences[seq_index].group_id
    sites = {}

    for i, item in enumerate(circuit.sequences):
        if((item.group_id == group_id) and item.id in {RECOMBINASE_SITE_B.id,
                                                       RECOMBINASE_SITE_P.id,
                                                       RECOMBINASE_SITE_L.id,
                                                       RECOMBINASE_SITE_R.id}):
            sites[item.id] = (i, item.orientation)
            if(len(sites) == 2):
                break

    # print(sites)
    inversion_replace_dict = {RECOMBINASE_SITE_B.id: RECOMBINASE_SITE_L.id,
                              RECOMBINASE_SITE_P.id: RECOMBINASE_SITE_R.id,
                              RECOMBINASE_SITE_L.id: RECOMBINASE_SITE_B.id,
                              RECOMBINASE_SITE_R.id: RECOMBINASE_SITE_P.id}

    cut_replace_dict = {RECOMBINASE_SITE_B.id: RECOMBINASE_SITE_PB.id,
                        RECOMBINASE_SITE_P.id: RECOMBINASE_SITE_PB.id,
                        RECOMBINASE_SITE_L.id: RECOMBINASE_SITE_LR.id,
                        RECOMBINASE_SITE_R.id: RECOMBINASE_SITE_LR.id}
    sites_list = list(sites.values())

    if ({RECOMBINASE_SITE_B.id, RECOMBINASE_SITE_P.id}.issubset(sites) or
            {RECOMBINASE_SITE_R.id, RECOMBINASE_SITE_L.id}.issubset(sites)):
        if(sites_list[0][1] ==
           sites_list[1][1]):
            # print("cut")
            results.append(
                actuator_recombinase_cut(circuit=circuit,
                                         index_site_1=sites_list[0][0],
                                         index_site_2=sites_list[1][0],
                                         replace_dict=cut_replace_dict))
        else:
            # print("invert")
            results.append(
                actuator_recombinase_invert(circuit=circuit,
                                            index_site_1=sites_list[0][0],
                                            index_site_2=sites_list[1][0],
                                            replace_dict=inversion_replace_dict))
            # print("corte pb")
    return results


def actuator_recombinase_cut(circuit: GeneticCircuit, index_site_1: int,
                             index_site_2: int, replace_dict: dict):
    # new_sequences = copy(circuit.sequences)
    new_sequences = [replace(sequence) for sequence in circuit.sequences]

    if(index_site_1 > index_site_2):
        index_site_1, index_site_2 = index_site_2, index_site_1

    site1 = replace(new_sequences[index_site_1],
                    id=replace_dict[new_sequences[index_site_1].id])
    # print("subseq:", index_site_1, index_site_2,
    #   new_sequences[index_site_1:index_site_2+1])
    new_sequences[index_site_1:index_site_2+1] = [site1]
    new_circuit = replace(circuit, sequences=new_sequences)
    resetGeneticCircuit(new_circuit)
    # new_circuit.previous_states.append(hash(circuit))
    # new_circuit.previous_states = [*circuit.previous_states, hash(circuit)]
    new_circuit.previous_states = [hash(circuit)]
    # new_circuit.previous_states.append(hash(circuit))
    return new_circuit


def actuator_recombinase_invert(circuit: GeneticCircuit, index_site_1: int,
                                index_site_2: int, replace_dict: dict):
    # new_sequences = circuit.sequences.copy()
    new_sequences = [replace(sequence) for sequence in circuit.sequences]
    new_sequences[index_site_1] = replace(new_sequences[index_site_1],
                                          id=replace_dict[new_sequences[index_site_1].id])
    new_sequences[index_site_2] = replace(new_sequences[index_site_2],
                                          id=replace_dict[new_sequences[index_site_2].id])

    if(index_site_1 > index_site_2):
        index_site_1, index_site_2 = index_site_2, index_site_1

    if(index_site_1-index_site_2 > 1):
        new_sequences[index_site_1+1:index_site_2] = list(
            map(flipSequenceOrientation,
                new_sequences[index_site_1+1:index_site_2]))

    new_circuit = replace(circuit, sequences=new_sequences)
    resetGeneticCircuit(new_circuit)
    # new_circuit.previous_states.append(hash(circuit))
    # new_circuit.previous_states = [*circuit.previous_states, hash(circuit)]
    new_circuit.previous_states = [hash(circuit)]
    # new_circuit.previous_states.append(hash(circuit))
    return new_circuit
