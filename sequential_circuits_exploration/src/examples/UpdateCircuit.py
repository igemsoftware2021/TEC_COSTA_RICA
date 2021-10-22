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


total_circuits = database.circuitsCollection.estimated_document_count()
print("Total circuits in database:", total_circuits)


circuit = generateCircuit(
    [GROUP_MINIMUM, GROUP_RECOMBINASE_TYROSIN, ])
print(circuit, "\n\n")
database.updateOneCircuit(circuit)






