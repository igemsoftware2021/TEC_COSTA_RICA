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
    conectionString=conectionString, databaseName="Test_SequentialCircuits")


database.circuitsCollection.delete_many({})

database.populate(SEQUENCETYPES)


total_circuits = database.circuitsCollection.estimated_document_count()
print("Total circuits in database:", total_circuits)


# GROUP_MINIMUM_2 = seq.SequenceGroup(0, "basic", [TERMINATOR, PROMOTER,PROMOTER])

circuit = generateCircuit(
    [GROUP_MINIMUM, GROUP_RECOMBINASE_TYROSIN,GROUP_RECOMBINASE_TYROSIN, ])
print(circuit, "\n\n")
database.updateOneCircuit(circuit)


total_permutations = calculateTotalPermutations(circuit)
print("Total permutations:", total_permutations)

# circuits = [*circuitPermutations(circuit)]

cir_permutations = circuitPermutations(circuit)

# use first 10000 permutations
circuits = [*islice(cir_permutations, 100000)]



# database.updateManyCircuits(circuits)


# count all the circuits on the database
total_circuits = database.circuitsCollection.count_documents({})
print("Total circuits in database:", total_circuits)


# count all the circuits on the database
validated_circuits = database.circuitsCollection.count_documents({
                                                                 "validated": True})
print("Validated circuits in database:", validated_circuits)


actuatorfunctions = {
    RECOMBINASE_TYROSINE.id: actuator_tyrosine_recombinase
}


while circuits:
    new_circuits = []
    for cir_n in circuits:
        promoterValidator(circuit=cir_n)
        new_circuits_temp = actuator(cir_n, actuatorfunctions)
        new_circuits = [*new_circuits, *new_circuits_temp]
    # update the current circuits expresing relatioships
    database.updateManyCircuits(circuits)

    circuits = []
    for new_cir in new_circuits:
        if not database.circuitValidated(new_cir.hash):
            circuits.append(new_cir)
    print("FILTERED NEW CIRCUITS", len(circuits))


# count all the circuits on the database
total_circuits = database.circuitsCollection.count_documents({})
print("Total circuits in database:", total_circuits)
