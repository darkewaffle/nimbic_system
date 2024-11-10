import /[reader, format_2da]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]

const
    RaceFileName = "racialtypes"
    RaceIgnoreLines = 3
    RaceIgnoreColumns = 0
    RaceReadColumns = 34
    RaceColumnRaceID = 0
    RaceColumnRaceLabel = 1
    RaceColumnStrMod = 10
    RaceColumnDexMod = 11
    RaceColumnIntMod = 12
    RaceColumnChaMod = 13
    RaceColumnWisMod = 14
    RaceColumnConMod = 15
    RaceColumnFeatFile = 18
    RaceColumnExtraSkillsPerLevel = 28
    RaceColumnFirstLevelSkillMultiplier = 29
    RaceColumnAbilitySkillPointModifier = 33
var
    Race2DA: seq[seq[string]]
    
proc Read2DA_Race*()
proc GetRaceLabel*(RaceID: int, Pretty: bool = false): string
proc GetRaceStrModification*(RaceID: int): int
proc GetRaceDexModification*(RaceID: int): int
proc GetRaceConModification*(RaceID: int): int
proc GetRaceIntModification*(RaceID: int): int
proc GetRaceWisModification*(RaceID: int): int
proc GetRaceChaModification*(RaceID: int): int
proc GetRaceAbilityModifiers*(RaceID: int): array[6, int]
proc GetRaceFeatFile*(RaceID: int): string
proc GetRaceExtraSkillPointsPerLevel*(RaceID: int): int
proc GetRaceFirstLevelSkillMultiplier*(RaceID: int): int
proc GetRaceSkillPointModifierAbility*(RaceID: int): string

proc Read2DA_Race*() =
    Race2DA = Read2DA(RaceFileName, RaceIgnoreLines, RaceIgnoreColumns, RaceReadColumns)

proc GetRaceLabel*(RaceID: int, Pretty: bool = false): string =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            if not(Pretty):
                return Race2DA[i][RaceColumnRaceLabel]
            else:
                return PrettyString(Race2DA[i][RaceColumnRaceLabel])
    return ""

proc GetRaceStrModification*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnStrMod])
    return 0

proc GetRaceDexModification*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnDexMod])
    return 0

proc GetRaceIntModification*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnIntMod])
    return 0

proc GetRaceChaModification*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnChaMod])
    return 0

proc GetRaceWisModification*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnWisMod])
    return 0

proc GetRaceConModification*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnConMod])
    return 0

proc GetRaceAbilityModifiers*(RaceID: int): array[6, int] =
    var AbilityModifiers = [0, 0, 0, 0, 0, 0]
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            AbilityModifiers[0] = SafeParseInt2DA(Race2DA[i][RaceColumnStrMod])
            AbilityModifiers[1] = SafeParseInt2DA(Race2DA[i][RaceColumnDexMod])
            AbilityModifiers[2] = SafeParseInt2DA(Race2DA[i][RaceColumnConMod])
            AbilityModifiers[3] = SafeParseInt2DA(Race2DA[i][RaceColumnIntMod])
            AbilityModifiers[4] = SafeParseInt2DA(Race2DA[i][RaceColumnWisMod])
            AbilityModifiers[5] = SafeParseInt2DA(Race2DA[i][RaceColumnChaMod])
    return AbilityModifiers

proc GetRaceFeatFile*(RaceID: int): string =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return Race2DA[i][RaceColumnFeatFile]
    return ""

proc GetRaceExtraSkillPointsPerLevel*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnExtraSkillsPerLevel])
    return 0

proc GetRaceFirstLevelSkillMultiplier*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnFirstLevelSkillMultiplier])
    return 0

proc GetRaceSkillPointModifierAbility*(RaceID: int): string =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return Race2DA[i][RaceColumnAbilitySkillPointModifier]
    return ""