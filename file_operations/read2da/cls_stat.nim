import /[reader, format_2da]
from classes import GetClassStatFile

const
    ClassStatIgnoreLines = 3
    ClassStatIgnoreColumns = 2
    ClassStatReadColumns = 7
    ClassStatColumnStrMod = 0
    ClassStatColumnDexMod = 1
    ClassStatColumnConMod = 2
    ClassStatColumnWisMod = 3
    ClassStatColumnIntMod = 4
    ClassStatColumnChaMod = 5
    ClassStatColumnNaturalAC = 6
var
    ClassStat2DA: seq[seq[string]]
    ClassStatLoaded: string

proc Read2DA_ClsStat(ClassStatFileName: string)
proc GetClassAbilityModifiers*(ClassID: int, ClassLevel: int): array[6, int]
proc GetClassNaturalAC*(ClassID: int, ClassLevel: int): int

proc Read2DA_ClsStat(ClassStatFileName: string) =
    if ClassStatFileName == ClassStatLoaded:
        discard
    else:
        ClassStat2DA = Read2DA(ClassStatFileName, ClassStatIgnoreLines, ClassStatIgnoreColumns, ClassStatReadColumns)
        ClassStatLoaded = ClassStatFileName

proc GetClassAbilityModifiers*(ClassID: int, ClassLevel: int): array[6, int] =
    var AbilityModifiers = [0, 0, 0, 0, 0, 0]
    var StatFile = GetClassStatFile(ClassID)
    if StatFile != "":
        Read2DA_ClsStat(StatFile)
    else:
        return AbilityModifiers

    for i in ClassStat2DA.low .. ClassStat2DA.high:
        if i + 1 > ClassLevel:
            break
        AbilityModifiers[0] = AbilityModifiers[0] + SafeParseInt2DA(ClassStat2DA[i][ClassStatColumnStrMod])
        AbilityModifiers[1] = AbilityModifiers[1] + SafeParseInt2DA(ClassStat2DA[i][ClassStatColumnDexMod])
        AbilityModifiers[2] = AbilityModifiers[2] + SafeParseInt2DA(ClassStat2DA[i][ClassStatColumnConMod])
        AbilityModifiers[3] = AbilityModifiers[3] + SafeParseInt2DA(ClassStat2DA[i][ClassStatColumnIntMod])
        AbilityModifiers[4] = AbilityModifiers[4] + SafeParseInt2DA(ClassStat2DA[i][ClassStatColumnWisMod])
        AbilityModifiers[5] = AbilityModifiers[5] + SafeParseInt2DA(ClassStat2DA[i][ClassStatColumnChaMod])

    return AbilityModifiers

proc GetClassNaturalAC*(ClassID: int, ClassLevel: int): int =
    var NaturalAC = 0
    var StatFile = GetClassStatFile(ClassID)
    if StatFile != "":
        Read2DA_ClsStat(StatFile)
    else:
        return NaturalAC

    for i in ClassStat2DA.low .. ClassStat2DA.high:
        if i + 1 > ClassLevel:
            break
        NaturalAC = NaturalAC + SafeParseInt2DA(ClassStat2DA[i][ClassStatColumnNaturalAC])
    return NaturalAC