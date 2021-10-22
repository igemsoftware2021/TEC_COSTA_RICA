from SGCE.circuitsDatabase import *
from SGCE.constants import *
from SGCE.sequences import *

conectionString = "mongodb://localhost:49154/"

database = CircuitDatabase(
    conectionString=conectionString, databaseName="SequentialCircuits")  # Change the databaseName for your prefered name

# insert the sequenceTypes into the database and create the corresponding indixes
database.populate(sequenceTypes=SEQUENCETYPES)

# request all the sequenceTypes on the database
sequenceTypesResult = database.sequenceTypesCollection.find({})

# reconstruct SequenceType Objects from database
for s_type_dict in sequenceTypesResult:
    s_type = dataclass_from_dict(SequenceType, s_type_dict)
    print(s_type)
