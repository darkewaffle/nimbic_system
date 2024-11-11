import /[reader, format_2da]
from racialtypes import GetRaceFeatFile

const
    RaceFeatIgnoreLines = 3
    RaceFeatIgnoreColumns = 1
    RaceFeatReadColumns = 2
    RaceFeatLabelColumn = 0
    RaceFeatIDColumn = 1
var
    RaceFeat2DA: seq[seq[string]]
    RaceFeatLoaded: string


proc Read2DA_RaceFeat(RaceFeatFileName: string)
proc GetRaceFeats*(RaceID: int): seq[int]

proc Read2DA_RaceFeat(RaceFeatFileName: string) =
    if RaceFeatFileName == RaceFeatLoaded:
        discard
    else:
        RaceFeat2DA = Read2DA(RaceFeatFileName, RaceFeatIgnoreLines, RaceFeatIgnoreColumns, RaceFeatReadColumns)
        RaceFeatLoaded = RaceFeatFileName

proc GetRaceFeats*(RaceID: int): seq[int] =
    Read2DA_RaceFeat(GetRaceFeatFile(RaceID))
    var FeatsForRace: seq[int]

    for i in RaceFeat2DA.low .. RaceFeat2DA.high:
        FeatsForRace.add(SafeParseInt2DA(RaceFeat2DA[i][RaceFeatIDColumn]))

    return FeatsForRace