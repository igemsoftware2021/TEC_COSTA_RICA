# export PYTHONPATH=${PYTHONPATH}:$(pwd)
# export PYTHONPATH=${PYTHONPATH}: path to ../Secuential-Circuits-Exploration/src/
# from SGCE import *

from SGCE.circuit import *
from SGCE.constants import *
from SGCE.sequences import *
from SGCE.circuitsDatabase import *
from SGCE.recombinase import *
from SGCE.generator import *
import numpy as np
# from itertools import permutations, product

database = CircuitDatabase()


# database.populate(seqTypeGroups=SEQUENCETYPEGROUPS,
#                   seqTypes=SEQUENCETYPES.values())


# from colorama import Fore, Back, Style


circuit = generateCircuit(
    [GROUP_MINIMUM, GROUP_RECOMBINASE_TYROSIN])
print(circuit, "\n\n")

circuits = [*circuitPermutations(circuit)]


# print("HASH:", hash(circuit))
new_circuits = []

# circuits = randomizeCircuit(circuit, 10, 10)


# for cir_n in circuits:
#     promoterValidator(circuit=cir_n)
#     if (RECOMBINASE_TYROSINE.id in cir_n.expresing):
#         # print("\n\n\nexpressing")
#         # print(cir_n, "\n")

#         for recom in cir_n.expresing[RECOMBINASE_TYROSINE.id]:
#             new_circuits.extend(
#                 actuator_tyrosine_recombinase(circuit=cir_n, seq_index=recom["index"]))
