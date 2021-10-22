from .sequences import *
from .circuit import *
import pymongo
from dataclasses import dataclass, field, replace, asdict, astuple
import itertools


class CircuitDatabase:
    def __init__(self, conectionString="mongodb://localhost:49153/",
                 databaseName="SequentialCircuits"):
        self.client = pymongo.MongoClient(conectionString)
        self.db = self.client[databaseName]
        self.circuitsCollection = self.db["Circuits"]
        self.sequenceTypesCollection = self.db["SequenceTypes"]
        # self.SequenceGroupsCollection = self.db["SequenceGroups"]

    def populate(self, sequenceTypes: list[SequenceType]):

        # create circuits index by hash
        self.circuitsCollection.create_index(
            [("hash", pymongo.ASCENDING)], unique=True)

        self.sequenceTypesCollection.create_index(
            [("id", pymongo.ASCENDING)], unique=True)

        for sequenceType in sequenceTypes.values():
            self.sequenceTypesCollection.update_one({"id": sequenceType.id},
                                                    {"$set": asdict(
                                                        sequenceType)},
                                                    upsert=True)
        # for sequenceTypeGroup in sequenceTypeGroups:
            # self.SequenceGroupsCollection.insert_one(asdict(sequenceTypeGroup))

    def updateOneCircuit(self, circuit: GeneticCircuit, upsert=True):
        circuit_dict = asdict(circuit)
        cir_hash = circuit_dict.pop('hash')

        self.circuitsCollection.update_one({"hash": cir_hash},
                                           {"$set": circuit_dict},
                                           upsert=True)

    def createUpdateQuery(self, circuit_dict: dict, upsert=True):
        addToSet_operators = {"next_states", "expresing",
                              "previous_states"}
        #   "expresing"}
        setOnInsert_operators = {"sequences",
                                 "sequencesGroups"}

        update_q = {}
        filter_q = {"hash": circuit_dict.pop('hash')}
        update_q["$addToSet"] = {
            key: {"$each": circuit_dict.pop(key)} for key in addToSet_operators}

        update_q["$setOnInsert"] = {
            key: circuit_dict.pop(key) for key in setOnInsert_operators}

        update_q["$set"] = circuit_dict
        return pymongo.UpdateOne(filter_q, update_q, upsert=upsert)

    def updateManyCircuits(self, circuits: list[GeneticCircuit], upsert=True):
        if len(circuits):
            circuits_dicts = map(asdict, circuits)
            queries = [*map(self.createUpdateQuery, circuits_dicts,
                            itertools.repeat(True))]

            self.circuitsCollection.bulk_write(queries, ordered=upsert)

    def circuitExist(self, cir_hash):
        return self.circuitsCollection.find(
            {"hash": cir_hash}, {"hash": 1}).count() > 0

    def circuitValidated(self, cir_hash):
        return self.circuitsCollection.find(
            {"hash": cir_hash, "validated": True}, {"hash": 1}).count() > 0



