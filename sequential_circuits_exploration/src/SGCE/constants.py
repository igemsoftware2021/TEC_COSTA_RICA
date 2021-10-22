from .sequences import *
from .dataclasses_utils import *

SEQUENCETYPES = {}
SEQUENCETYPEGROUPS = []

UNDEFINED_SEQUENCE = createSequenceType(SEQUENCETYPES,
                                        id=0, name="undefined",
                                        expresable=False)

TERMINATOR = createSequenceType(
    SEQUENCETYPES, id=1, name="terminator", expresable=False)

PROMOTER = createSequenceType(
    SEQUENCETYPES, id=2, name="promoter", expresable=False)

GENE = createSequenceType(
    SEQUENCETYPES, id=3, name="gene", expresable=True)

RECOMBINASE_TYROSINE = createSequenceType(SEQUENCETYPES,
                                          id=4,
                                          name="tyrosine recombinase",
                                          expresable=True)

RECOMBINASE_SERINE = createSequenceType(SEQUENCETYPES,
                                        id=5, name="serine recombinase",
                                        expresable=True)

RECOMBINASE_SITE_P = createSequenceType(SEQUENCETYPES,
                                        id=6, name="recombinase site P",
                                        expresable=False)

RECOMBINASE_SITE_B = createSequenceType(SEQUENCETYPES,
                                        id=7, name="recombinase site B",
                                        expresable=False)

RECOMBINASE_SITE_L = createSequenceType(SEQUENCETYPES,
                                        id=8, name="recombinase site L",
                                        expresable=False)

RECOMBINASE_SITE_R = createSequenceType(SEQUENCETYPES,
                                        id=9, name="recombinase site R",
                                        expresable=False)

RECOMBINASE_SITE_PB = createSequenceType(SEQUENCETYPES,
                                         id=10, name="recombinase site PB",
                                         expresable=False)

RECOMBINASE_SITE_LR = createSequenceType(SEQUENCETYPES,
                                         id=11, name="recombinase site LR",
                                         expresable=False)
RECOMBINASE_DF = createSequenceType(SEQUENCETYPES,
                                    id=12, name="recombinase DF",
                                    expresable=False)


GROUP_MINIMUM = SequenceGroup(0, "basic", [TERMINATOR, PROMOTER])

GROUP_RECOMBINASE_SERINE_PB = SequenceGroup(1, "serine recombinase", [
    RECOMBINASE_SERINE,
    RECOMBINASE_DF,
    RECOMBINASE_SITE_B,
    RECOMBINASE_SITE_P])

GROUP_RECOMBINASE_SERINE_LR = SequenceGroup(1, "serine recombinase", [
    RECOMBINASE_SERINE,
    RECOMBINASE_DF,
    RECOMBINASE_SITE_L,
    RECOMBINASE_SITE_R])

GROUP_RECOMBINASE_TYROSIN = SequenceGroup(
    2, "tyrosin recombinase", [RECOMBINASE_TYROSINE,
                               RECOMBINASE_SITE_B,
                               RECOMBINASE_SITE_P])


SEQUENCETYPEGROUPS = [GROUP_MINIMUM,
                      GROUP_RECOMBINASE_SERINE_PB,
                      GROUP_RECOMBINASE_TYROSIN]


# print("SE EJECUTO")
# print(SEQUENCETYPES)
# print(SEQUENCETYPEGROUPS)
