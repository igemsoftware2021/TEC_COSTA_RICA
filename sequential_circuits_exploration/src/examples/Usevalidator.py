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
database.populate(SEQUENCETYPES)

database.circuitsCollection.delete_many({})
total_circuits = database.circuitsCollection.estimated_document_count()
print("Total circuits in database:", total_circuits)


# GROUP_MINIMUM_2 = seq.SequenceGroup(0, "basic", [TERMINATOR, PROMOTER,PROMOTER])

circuit = generateCircuit(
    [GROUP_MINIMUM, GROUP_RECOMBINASE_TYROSIN, GROUP_RECOMBINASE_TYROSIN])
print(circuit, "\n\n")
database.updateOneCircuit(circuit)


total_permutations = calculateTotalPermutations(circuit)
print("Total permutations:", total_permutations)


# cir_permutations = circuitPermutations(circuit)
cir_permutations = circuitOrderPermutations(circuit)

# use first 10000 permutations
circuits = [*islice(cir_permutations, 100000)]


# circuits = [*circuitPermutations(circuit)]

# circuits = [*cir_permutations][:10000]
database.updateManyCircuits(circuits)


# count all the circuits on the database
total_circuits = database.circuitsCollection.estimated_document_count()
print("Total circuits in database:", total_circuits)


# count all the circuits on the database
validated_circuits = database.circuitsCollection.count_documents({
                                                                 "validated": True})
print("Validated circuits in database:", validated_circuits)


for cir_n in circuits:
    promoterValidator(circuit=cir_n)

database.updateManyCircuits(circuits)


# count all the validated circuits on the database
validated_circuits = database.circuitsCollection.count_documents({
                                                                 "validated": True})
print("Validated circuits in database:", validated_circuits)

actuatorfunctions = {
    RECOMBINASE_TYROSINE.id: actuator_tyrosine_recombinase
}

new_circuits = []
for cir_n in circuits:
    new_circuits_temp = actuator(cir_n, actuatorfunctions)

    # if(new_circuits_temp):
    #     for nc in new_circuits_temp:
    #         if(len(nc.sequences) != len(cir_n.sequences)):
    #             print("###################################")
    #             print(len(nc.sequences), len(cir_n.sequences))
    #             print(cir_n, "\n\n", new_circuits_temp, "\n\n")

    new_circuits = [*new_circuits, *new_circuits_temp]


print("New circuits:", len(new_circuits))

# update the current circuits expresing relatioships
database.updateManyCircuits(circuits)

# update the current circuits expresing relatioships
database.updateManyCircuits(new_circuits, upsert=True)


# count all the circuits on the database
total_circuits = database.circuitsCollection.estimated_document_count()
print("Total circuits in database:", total_circuits)

# count all the validated circuits on the database
new_circuits_count = database.circuitsCollection.count_documents({
                                                                 "validated": False})
print("New circuits in database:", new_circuits_count)
