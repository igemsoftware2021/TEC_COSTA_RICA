from enum import Enum, unique
from SGCE.dataclasses_utils import *

BIDIRECTIONAL = 0
FORWARD = 1
REVERSE = 2


@dataclass
class SequenceType:
    id: int
    name: str
    expresable: bool = False
    default_orientation: int = FORWARD


@dataclass
class Sequence:
    id: int
    group_id: int
    orientation: int = FORWARD
    expresable: bool = False


def createSequence(sequenceType: SequenceType, group_id: int):
    return Sequence(sequenceType.id, group_id=group_id,
                    orientation=sequenceType.default_orientation,
                    expresable=sequenceType.expresable)


@dataclass
class SequenceGroup:
    id: int
    name: str
    sequences: list[SequenceType]


def createSequenceType(sequenceTypesList: dict, id: int, name: str, expresable: bool = False):
    if (id not in sequenceTypesList):
        new_type = SequenceType(id=id, name=name, expresable=expresable)
        sequenceTypesList[id] = new_type
        return new_type
    else:
        raise Exception("id already registered")


def flipSequenceOrientation(sequence: Sequence):
    replacement = {REVERSE: FORWARD,
                   FORWARD: REVERSE,
                   BIDIRECTIONAL: BIDIRECTIONAL}
    return replace(sequence, orientation=replacement[sequence.orientation])


def setSequenceOrientation(sequence: Sequence, orientation: int):
    return replace(sequence, orientation=orientation)


def dict_to_sequence(sequence_dict: dict):
    return dataclass_from_dict(Sequence, sequence_dict)


def dict_to_sequence_type(sequence_type_dict: dict):
    return dataclass_from_dict(SequenceType, sequence_type_dict)


def dict_to_sequence_group(sequence_group_dict: dict):
    sequences = []
    for sequence_type_dict in sequence_group_dict["sequences"]:
        sequences.append(dict_to_sequence_type(sequence_type_dict))
    result_sg = SequenceGroup(id=sequence_group_dict["id"],
                              name=sequence_group_dict["name"],
                              sequences=sequences)
    return result_sg


SequenceGroup
