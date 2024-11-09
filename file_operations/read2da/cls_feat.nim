import /[reader, format_2da]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]
from classes import GetClassFeatFile

const
    ClassFeatIgnoreLines = 3
    ClassFeatIgnoreColumns = 1
    ClassFeatReadColumns = 4
    ClassFeatLabelColumn = 0
    ClassFeatIDColumn = 1
    ClassFeatLevelGrantedColumn = 3
var
    ClassFeat2DA: seq[seq[string]]
    ClassFeatLoaded: string

proc Read2DA_ClsFeat(ClassFeatFileName: string)
proc GetClassFeatLevel*(ClassID: int, FeatID: int): int
proc GetClassFeatsAtLevel*(ClassID: int, Level: int): seq[int]

proc Read2DA_ClsFeat(ClassFeatFileName: string) =
    if ClassFeatFileName == ClassFeatLoaded:
        discard
    else:
        ClassFeat2DA = Read2DA(ClassFeatFileName, ClassFeatIgnoreLines, ClassFeatIgnoreColumns, ClassFeatReadColumns)
        ClassFeatLoaded = ClassFeatFileName

proc GetClassFeatLevel*(ClassID: int, FeatID: int): int =
    Read2DA_ClsFeat(GetClassFeatFile(ClassID))
    for i in ClassFeat2DA.low .. ClassFeat2DA.high:
        if SafeParseInt2DA(ClassFeat2DA[i][ClassFeatIDColumn]) == FeatID:
            return SafeParseInt2DA(ClassFeat2DA[i][ClassFeatLevelGrantedColumn])
    return 0

proc GetClassFeatsAtLevel*(ClassID: int, Level: int): seq[int] =
    Read2DA_ClsFeat(GetClassFeatFile(ClassID))
    var FeatsForClassLevel: seq[int]

    for i in ClassFeat2DA.low .. ClassFeat2DA.high:
        if SafeParseInt2DA(ClassFeat2DA[i][ClassFeatLevelGrantedColumn]) == Level:
            FeatsForClassLevel.add(SafeParseInt2DA(ClassFeat2DA[i][ClassFeatIDColumn]))

    return FeatsForClassLevel