from SGCE.circuitsDatabase import *
from SGCE.constants import *
from SGCE.sequences import *
from SGCE.circuit import *

conectionString = "mongodb://localhost:49154/"


# Change databaseName if needed
database = CircuitDatabase(
    conectionString=conectionString, databaseName="SecuentialCircuits")

# request all the sequenceTypes on the database
total_circuits = database.circuitsCollection.estimated_document_count()
print(total_circuits)
# # reconstruct SequenceType Objects from database
# for s_type_dict in sequenceTypesResult:
#     s_type = dataclass_from_dict(SequenceType, s_type_dict)
#     print(s_type)
