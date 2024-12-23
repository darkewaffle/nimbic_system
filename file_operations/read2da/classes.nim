import /[reader, format_2da]

const
    ClassFileName = "classes"
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
proc GetClassLabel*(ClassID: int, Pretty: bool = false, Shortened: bool = false): string
proc GetClassHPPerLevel*(ClassID: int): int
proc GetClassFeatFile*(ClassID: int): string
proc GetClassSkillPointsPerLevel*(ClassID: int): int
proc GetClassStatFile*(ClassID: int): string
proc GetClassSpellbookRestricted*(ClassID: int): bool

proc Read2DA_Class*() =
    Class2DA = Read2DA(ClassFileName, ClassIgnoreLines, ClassIgnoreColumns, ClassReadColumns)

proc GetClassLabel*(ClassID: int, Pretty: bool = false, Shortened: bool = false): string =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            if Pretty:
                return PrettyString(Class2DA[i][ClassColumnClassLabel])
            elif Shortened:
                return ShortenedString(Class2DA[i][ClassColumnClassLabel])
            else:
                return Class2DA[i][ClassColumnClassLabel]
    return ""

proc GetClassHPPerLevel*(ClassID: int): int =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            return SafeParseInt2DA(Class2DA[i][ClassColumnHP])
    return 0

proc GetClassFeatFile*(ClassID: int): string =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            return Class2DA[i][ClassColumnFeatFile]
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
                return Class2DA[i][ClassColumnStatFile]
    return ""

proc GetClassSpellbookRestricted*(ClassID: int): bool =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            return SafeParseInt2DA(Class2DA[i][ClassColumnSpellbookRestricted]).bool
    return false

















