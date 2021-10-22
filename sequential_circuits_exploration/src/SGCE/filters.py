from SGCE.circuit import *
from SGCE.constants import *
from SGCE.sequences import *
from SGCE.circuitsDatabase import *
from SGCE.recombinase import *
from SGCE.generator import *
from SGCE.dataclasses_utils import *


def count(database: CircuitDatabase, filter={}):
    return database.circuitsCollection.find(filter, {"_id": 1}).count()


def filterBySequences(database: CircuitDatabase, filter={}):
    return database.circuitsCollection.find(filter, {"_id": 1}).count()


# FILTERS
    # "ciclicas"
    # "no_ciclicas
    # "size"
    # "n_inmediate_sons"
    # "n_promoters"


def get_database_stats(database: CircuitDatabase, stats_query):
    result = database.circuitsCollection.aggregate(
        STATS_QUERIES[stats_query]["stages"])

    return database.circuitsCollection.aggregate()
