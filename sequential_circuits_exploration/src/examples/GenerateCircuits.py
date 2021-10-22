from SGCE.circuit import *
from SGCE.constants import *
from SGCE.sequences import *
from SGCE.circuitsDatabase import *
from SGCE.recombinase import *
from SGCE.generator import *
from SGCE.dataclasses_utils import *
import numpy as np

conectionString = "mongodb://localhost:49154/"

# Change databaseName if needed
database = CircuitDatabase(
    conectionString=conectionString, databaseName="SequentialCircuits")


database.circuitsCollection.delete_many({})
total_circuits = database.circuitsCollection.estimated_document_count()
print("Total circuits in database:", total_circuits)


# GROUP_MINIMUM_2 = seq.SequenceGroup(0, "basic", [TERMINATOR, PROMOTER,PROMOTER])

circuit = generateCircuit(
    [GROUP_MINIMUM, GROUP_RECOMBINASE_TYROSIN, ])
print(circuit, "\n\n")
database.updateOneCircuit(circuit)


total_permutations = calculateTotalPermutations(circuit)
print("Total permutations:", total_permutations)

circuits = [*circuitPermutations(circuit)]

database.updateManyCircuits(circuits)



# count all the circuits on the database
total_circuits = database.circuitsCollection.estimated_document_count()
print("Total circuits in database:", total_circuits)



# # reconstruct SequenceType Objects from database
# for s_type_dict in sequenceTypesResult:
#     s_type = dataclass_from_dict(SequenceType, s_type_dict)
#     print(s_type)



