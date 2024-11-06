import std/[files, paths, strutils]
import echo_feedback
import object_settingspackage

const
#General purpose
    Extension2DA = ".2da"

#classes.2da
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

#racialtypes.2da
    RaceFileName = "racialtypes.2da"
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

#cls_feat_x.2da
    ClassFeatIgnoreLines = 3
    ClassFeatIgnoreColumns = 1
    ClassFeatReadColumns = 4
    ClassFeatLabelColumn = 0
    ClassFeatIDColumn = 1
    ClassFeatLevelGrantedColumn = 3

#cls_feat_x.2da
    RaceFeatIgnoreLines = 3
    RaceFeatIgnoreColumns = 1
    RaceFeatReadColumns = 2
    RaceFeatLabelColumn = 0
    RaceFeatIDColumn = 1

#cls_stat_x.2da
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

#ruleset.2da
    RulesetFileName = "ruleset.2da"
    RulesetIgnoreLines = 10
    RulesetIgnoreColumns = 1
    RulesetReadColumns = 2
    RulesetLabelColumn = 0
    RulesetValueColumn = 1

#feat.2da
    FeatFileName = "feat.2da"
    FeatIgnoreLines = 3
    FeatIgnoreColumns = 0
    FeatReadColumns = 2
    FeatColumnFeatID = 0
    FeatColumnFeatLabel = 1

#skills.2da
    SkillFileName = "skills.2da"
    SkillIgnoreLines = 3
    SkillIgnoreColumns = 0
    SkillReadColumns = 2
    SkillColumnSkillID = 0
    SkillColumnSkillLabel = 1

#spells.2da
    SpellFileName = "spells.2da"
    SpellIgnoreLines = 3
    SpellIgnoreColumns = 0
    SpellReadColumns = 2
    SpellColumnSpellID = 0
    SpellColumnSpellLabel = 1

var
    Directory2DA: string
    Class2DA: seq[seq[string]]
    Race2DA: seq[seq[string]]
    Ruleset2DA: seq[seq[string]]
    ClassFeat2DA: seq[seq[string]]
    ClassFeatLoaded: string
    ClassStat2DA: seq[seq[string]]
    ClassStatLoaded: string
    Feat2DA: seq[seq[string]]
    Skill2DA: seq[seq[string]]
    Spell2DA: seq[seq[string]]
    RaceFeat2DA: seq[seq[string]]
    RaceFeatLoaded: string

proc Initialize2DAs*(OperationSettings: SettingsPackage)
proc Read2DA(FileDirectory: string, FileName: string, IgnoreFirstLines: int = 0, IgnoreFirstColumns: int = 0, ColumnsToRead: int = 1): seq[seq[string]]
proc SafeParseInt2DA(Input: string): int

proc GetClassSkillPointsPerLevel*(ClassID: int): int
proc GetClassHPPerLevel*(ClassID: int): int
proc GetClassFeatFile*(ClassID: int): string
proc ReadClassFeats(ClassFeatFileName: string)
proc GetClassStatFile*(ClassID: int): string
proc GetClassAbilityModifiers*(ClassID: int, ClassLevel: int): array[6, int]
proc GetClassNaturalAC*(ClassID: int, ClassLevel: int): int

proc GetRaceStrModification*(RaceID: int): int
proc GetRaceDexModification*(RaceID: int): int
proc GetRaceConModification*(RaceID: int): int
proc GetRaceIntModification*(RaceID: int): int
proc GetRaceWisModification*(RaceID: int): int
proc GetRaceChaModification*(RaceID: int): int
proc GetRaceAbilityModifiers*(RaceID: int): array[6, int]
proc GetRaceFeatFile*(RaceID: int): string
proc ReadRaceFeats(RaceFeatFileName: string)
proc GetRaceFeats*(RaceID: int): seq[int]

proc GetRaceExtraSkillPointsPerLevel*(RaceID: int): int
proc GetRaceFirstLevelSkillMultiplier*(RaceID: int): int
proc GetRaceSkillPointModifierAbility*(RaceID: int): string

proc GetRulesetValue*(RulesetLabel: string): float
proc GetClassFeatLevel*(ClassID: int, FeatID: int): int
proc GetClassFeatsAtLevel*(ClassID: int, Level: int): seq[int]

proc GetFeatLabel*(FeatID: int, Pretty: bool = false): string
proc GetSkillLabel*(SkillID: int, Pretty: bool = false): string
proc GetRaceLabel*(RaceID: int, Pretty: bool = false): string
proc GetClassLabel*(ClassID: int, Pretty: bool = false): string
proc GetSpellLabel*(SpellID: int, Pretty: bool = false): string

proc PrettyString(Input: string): string


proc Initialize2DAs*(OperationSettings: SettingsPackage) =
    echo "2DA Reads Initialized"
    Directory2DA = OperationSettings.Input2DA
    Class2DA = Read2DA(Directory2DA, ClassFileName, ClassIgnoreLines, ClassIgnoreColumns, ClassReadColumns)
    Race2DA = Read2DA(Directory2DA, RaceFileName, RaceIgnoreLines, RaceIgnoreColumns, RaceReadColumns)
    Ruleset2DA = Read2DA(Directory2DA, RulesetFileName, RulesetIgnoreLines, RulesetIgnoreColumns, RulesetReadColumns)
    Feat2DA = Read2DA(Directory2DA, FeatFileName, FeatIgnoreLines, FeatIgnoreColumns, FeatReadColumns)
    Skill2DA = Read2DA(Directory2DA, SkillFileName, SkillIgnoreLines, SkillIgnoreColumns, SkillReadColumns)
    Spell2DA = Read2DA(Directory2DA, SpellFileName, SpellIgnoreLines, SpellIgnoreColumns, SpellReadColumns)
    echo "2DA Reads Complete"


#[
    for i in Class2DA.low .. Class2DA.high:
        echo Class2DA[i]
    for i in Race2DA.low .. Race2DA.high:
        echo Race2DA[i]
    for i in Ruleset2DA.low .. Ruleset2DA.high:
        echo Ruleset2DA[i]
    for i in Feat2DA.low .. Feat2DA.high:
        echo Feat2DA[i]
    for i in Skill2DA.low .. Skill2DA.high:
        echo Skill2DA[i]
]#

proc Read2DA(FileDirectory: string, FileName: string, IgnoreFirstLines: int = 0, IgnoreFirstColumns: int = 0, ColumnsToRead: int = 1): seq[seq[string]] =
    var
        CountLines = 0 - IgnoreFirstLines
        CountColumns = 0 - IgnoreFirstColumns
        FileContents: seq[seq[string]]
        LineContents: seq[string]
        FullPath: string

    if FileDirectory != "":
        if FileDirectory.endsWith("""\"""):
            FullPath = FileDirectory & FileName
        else:
            FullPath = FileDirectory & """\""" & FileName

    if not(fileExists(Path FullPath)):
        EchoError("2DA " & $FullPath & " was not found.")
        quit(QuitSuccess)

    for line in FullPath.lines:
        if CountLines < 0:
            discard
        else:
            for item in line.splitWhiteSpace(-1):
                if CountColumns < 0:
                    discard
                elif CountColumns < ColumnsToRead:
                    LineContents.insert(item, CountColumns)
                else:
                    break
                inc CountColumns
            FileContents.add(LineContents)
        inc CountLines
        CountColumns = 0 - IgnoreFirstColumns
        LineContents = @[]
    return FileContents


proc SafeParseInt2DA(Input: string): int =
    if Input == "****":
        return 0
    else:
        return parseInt(Input)


proc GetClassSkillPointsPerLevel*(ClassID: int): int =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            return SafeParseInt2DA(Class2DA[i][ClassColumnSkillPoints])
    return 0


proc GetClassHPPerLevel*(ClassID: int): int =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            return SafeParseInt2DA(Class2DA[i][ClassColumnHP])
    return 0


proc GetClassSpellbookRestricted*(ClassID: int): bool =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            return SafeParseInt2DA(Class2DA[i][ClassColumnSpellbookRestricted]).bool
    return false


proc GetClassFeatFile*(ClassID: int): string =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            return Class2DA[i][ClassColumnFeatFile] & Extension2DA
    return ""


proc ReadClassFeats(ClassFeatFileName: string) =
    if ClassFeatFileName == ClassFeatLoaded:
        discard
    else:
        ClassFeat2DA = Read2DA(Directory2DA, ClassFeatFileName, ClassFeatIgnoreLines, ClassFeatIgnoreColumns, ClassFeatReadColumns)
        ClassFeatLoaded = ClassFeatFileName


proc GetClassFeatLevel*(ClassID: int, FeatID: int): int =
    ReadClassFeats(GetClassFeatFile(ClassID))
    for i in ClassFeat2DA.low .. ClassFeat2DA.high:
        if SafeParseInt2DA(ClassFeat2DA[i][ClassFeatIDColumn]) == FeatID:
            return SafeParseInt2DA(ClassFeat2DA[i][ClassFeatLevelGrantedColumn])
    return 0

proc GetClassFeatsAtLevel*(ClassID: int, Level: int): seq[int] =
    ReadClassFeats(GetClassFeatFile(ClassID))
    var FeatsForClassLevel: seq[int]

    for i in ClassFeat2DA.low .. ClassFeat2DA.high:
        if SafeParseInt2DA(ClassFeat2DA[i][ClassFeatLevelGrantedColumn]) == Level:
            FeatsForClassLevel.add(SafeParseInt2DA(ClassFeat2DA[i][ClassFeatIDColumn]))

    return FeatsForClassLevel

proc GetClassStatFile*(ClassID: int): string =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            if Class2DA[i][ClassColumnStatFile] == "****":
                return ""
            else:
                return Class2DA[i][ClassColumnStatFile] & Extension2DA
    return ""

proc ReadClassStats(ClassStatFileName: string) =
    if ClassStatFileName == ClassStatLoaded:
        discard
    else:
        ClassStat2DA = Read2DA(Directory2DA, ClassStatFileName, ClassStatIgnoreLines, ClassStatIgnoreColumns, ClassStatReadColumns)
        ClassStatLoaded = ClassStatFileName

proc GetClassAbilityModifiers*(ClassID: int, ClassLevel: int): array[6, int] =
    var AbilityModifiers = [0, 0, 0, 0, 0, 0]
    var StatFile = GetClassStatFile(ClassID)
    if StatFile != "":
        ReadClassStats(StatFile)
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
        ReadClassStats(StatFile)
    else:
        return NaturalAC

    for i in ClassStat2DA.low .. ClassStat2DA.high:
        if i + 1 > ClassLevel:
            break
        NaturalAC = NaturalAC + SafeParseInt2DA(ClassStat2DA[i][ClassStatColumnNaturalAC])
    return NaturalAC


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

proc GetRaceConModification*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnConMod])
    return 0

proc GetRaceIntModification*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnIntMod])
    return 0

proc GetRaceWisModification*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnWisMod])
    return 0

proc GetRaceChaModification*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnChaMod])
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
            return Race2DA[i][RaceColumnFeatFile] & Extension2DA
    return ""

proc ReadRaceFeats(RaceFeatFileName: string) =
    if RaceFeatFileName == RaceFeatLoaded:
        discard
    else:
        RaceFeat2DA = Read2DA(Directory2DA, RaceFeatFileName, RaceFeatIgnoreLines, RaceFeatIgnoreColumns, RaceFeatReadColumns)
        RaceFeatLoaded = RaceFeatFileName

proc GetRaceFeats*(RaceID: int): seq[int] =
    ReadRaceFeats(GetRaceFeatFile(RaceID))
    var FeatsForRace: seq[int]

    for i in RaceFeat2DA.low .. RaceFeat2DA.high:
        FeatsForRace.add(SafeParseInt2DA(RaceFeat2DA[i][RaceFeatIDColumn]))

    return FeatsForRace

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

proc GetRulesetValue*(RulesetLabel: string): float =
    var RulesetValue: string
    for i in Ruleset2DA.low .. Ruleset2DA.high:
        if Ruleset2DA[i][RulesetLabelColumn] == RulesetLabel:
            RulesetValue = Ruleset2DA[i][RulesetValueColumn]

    if RulesetValue == "":
        return 0.float
    elif RulesetValue == "****":
        return 0.float
    elif count(RulesetValue, "f")>0:
        return parseFloat(replace(RulesetValue, "f", ""))
    else:
        return parseFloat(RulesetValue)

proc GetFeatLabel*(FeatID: int, Pretty: bool = false): string =
    for i in Feat2DA.low .. Feat2DA.high:
        if SafeParseInt2DA(Feat2DA[i][FeatColumnFeatID]) == FeatID:
            if not(Pretty):
                return Feat2DA[i][FeatColumnFeatLabel]
            else:
                return PrettyString(Feat2DA[i][FeatColumnFeatLabel])
    return ""

proc GetSkillLabel*(SkillID: int, Pretty: bool = false): string =
    for i in Skill2DA.low .. Skill2DA.high:
        if SafeParseInt2DA(Skill2DA[i][SkillColumnSkillID]) == SkillID:
            if not(Pretty):
                return Skill2DA[i][SkillColumnSkillLabel]
            else:
                return PrettyString(Skill2DA[i][SkillColumnSkillLabel])
    return ""

proc GetSpellLabel*(SpellID: int, Pretty: bool = false): string =
    for i in Spell2DA.low .. Spell2DA.high:
        if SafeParseInt2DA(Spell2DA[i][SpellColumnSpellID]) == SpellID:
            if not(Pretty):
                return Spell2DA[i][SpellColumnSpellLabel]
            else:
                return PrettyString(Spell2DA[i][SpellColumnSpellLabel])
    return ""

proc GetRaceLabel*(RaceID: int, Pretty: bool = false): string =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            if not(Pretty):
                return Race2DA[i][RaceColumnRaceLabel]
            else:
                return PrettyString(Race2DA[i][RaceColumnRaceLabel])
    return ""

proc GetClassLabel*(ClassID: int, Pretty: bool = false): string =
    for i in Class2DA.low .. Class2DA.high:
        if SafeParseInt2DA(Class2DA[i][ClassColumnClassID]) == ClassID:
            if not(Pretty):
                return Class2DA[i][ClassColumnClassLabel]
            else:
                return PrettyString(Class2DA[i][ClassColumnClassLabel])
    return ""

proc PrettyString(Input: string): string =
    var 
        Preparation = Input
        WordContainer: string
        Final: string

    removePrefix(Preparation, " ")
    removePrefix(Preparation, "FEAT_")
    removeSuffix(Preparation, " ")
    Preparation = Preparation.replace("_", " ")

    if contains(Preparation, " "):
        Preparation = toLower(Preparation)

        for i in Preparation.low .. Preparation.high:

            if not(isSpaceAscii(Preparation[i])):
                WordContainer = WordContainer & Preparation[i]
            else:
                WordContainer = capitalizeAscii(WordContainer)
                Final = Final & WordContainer & " "
                WordContainer = ""

            if i == Preparation.high:
                WordContainer = capitalizeAscii(WordContainer)
                Final = Final & WordContainer
    else:
        var SequentialDigits = 0
        for i in Preparation.low .. Preparation.high:
            if i == 0:
                Final = capitalizeAscii($Preparation[i])
            else:
                if isUpperAscii(Preparation[i]) or isDigit(Preparation[i]):
                    if isDigit(Preparation[i]):
                        inc SequentialDigits
                    else:
                        SequentialDigits = 0
                    if isDigit(Preparation[i]) and SequentialDigits > 1:
                        Final = Final & Preparation[i]
                    else:
                        Final = Final & " " & Preparation[i]
                else:
                    Final = Final & Preparation[i]
    return Final