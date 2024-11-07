import /[constants_2da, reader, format_2da]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]

const
    ClassFileName = "classes.2da"
    ClassIgnoreLines = 3
    ClassIgnoreColumns = 0
    ClassReadColumns = 59
    ClassColumnClassID = 0
    ClassColumnClassLabel = 1
    ClassColumnHP = 7
    ClassColumnBABFile = 8
    ClassColumnFeatFile = 9
    ClassColumnSavesFile = 10
    ClassColumnSkillPoints = 13
    ClassColumnStatFile = 56
    ClassColumnSpellbookRestricted = 58
var
    Class2DA: seq[seq[string]]

proc Read2DA_Class*()
proc GetClassLabel*(ClassID: int, Pretty: bool = false): string
proc GetClassHPPerLevel*(ClassID: int): int
proc GetClassFeatFile*(ClassID: int): string
proc GetClassSkillPointsPerLevel*(ClassID: int): int
proc GetClassStatFile*(ClassID: int): string
proc GetClassSpellbookRestricted*(ClassID: int): bool

proc Read2DA_Class*() =
    Class2DA = Read2DA(ClassFileName, ClassIgnoreLines, ClassIgnoreColumns, ClassReadColumns)

proc GetClassLabel*(ClassID: int, Pretty: bool = false): string =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            if not(Pretty):
                return Class2DA[i][ClassColumnClassLabel]
            else:
                return PrettyString(Class2DA[i][ClassColumnClassLabel])
    return ""

proc GetClassHPPerLevel*(ClassID: int): int =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            return SafeParseInt2DA(Class2DA[i][ClassColumnHP])
    return 0

proc GetClassFeatFile*(ClassID: int): string =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            return Class2DA[i][ClassColumnFeatFile] & Extension2DA
    return ""

proc GetClassSkillPointsPerLevel*(ClassID: int): int =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            return SafeParseInt2DA(Class2DA[i][ClassColumnSkillPoints])
    return 0

proc GetClassStatFile*(ClassID: int): string =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            if Class2DA[i][ClassColumnStatFile] == "****":
                return ""
            else:
                return Class2DA[i][ClassColumnStatFile] & Extension2DA
    return ""

proc GetClassSpellbookRestricted*(ClassID: int): bool =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            return SafeParseInt2DA(Class2DA[i][ClassColumnSpellbookRestricted]).bool
    return false

















