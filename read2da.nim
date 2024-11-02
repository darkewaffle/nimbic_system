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
    ClassReadColumns = 14
    ClassColumnClassID = 0
    ClassColumnHP = 7
    ClassColumnBABFile = 8
    ClassColumnFeatFile = 9
    ClassColumnSavesFile = 10
    ClassColumnSkillPoints = 13

#racialtypes.2da
    RaceFileName = "racialtypes.2da"
    RaceIgnoreLines = 3
    RaceIgnoreColumns = 0
    RaceReadColumns = 34
    RaceColumnRaceID = 0
    RaceColumnIntMod = 12
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

#ruleset.2da
    RulesetFileName = "ruleset.2da"
    RulesetIgnoreLines = 10
    RulesetIgnoreColumns = 1
    RulesetReadColumns = 2
    RulesetLabelColumn = 0
    RulesetValueColumn = 1

var
    Directory2DA: string
    Class2DA: seq[seq[string]]
    Race2DA: seq[seq[string]]
    Ruleset2DA: seq[seq[string]]
    ClassFeat2DA: seq[seq[string]]
    ClassFeatLoaded: string

proc Initialize2DAs*(OperationSettings: SettingsPackage)
proc Read2DA(FileDirectory: string, FileName: string, IgnoreFirstLines: int = 0, IgnoreFirstColumns: int = 0, ColumnsToRead: int = 1): seq[seq[string]]
proc SafeParseInt2DA(Input: string): int

proc GetClassSkillPointsPerLevel*(ClassID: int): int
proc GetClassHPPerLevel*(ClassID: int): int
proc GetClassFeatFile*(ClassID: int): string
proc ReadClassFeats(ClassFeatFileName: string)

proc GetRaceIntModification*(RaceID: int): int
proc GetRaceExtraSkillPointsPerLevel*(RaceID: int): int
proc GetRaceFirstLevelSkillMultiplier*(RaceID: int): int
proc GetRaceSkillPointModifierAbility*(RaceID: int): string

proc GetRulesetValue*(RulesetLabel: string): float
proc GetClassFeatLevel*(ClassID: int, FeatID: int): int


proc Initialize2DAs*(OperationSettings: SettingsPackage) =
    echo "2DA Reads Initialized"
    Directory2DA = OperationSettings.Input2DA
    Class2DA = Read2DA(Directory2DA, ClassFileName, ClassIgnoreLines, ClassIgnoreColumns, ClassReadColumns)
    Race2DA = Read2DA(Directory2DA, RaceFileName, RaceIgnoreLines, RaceIgnoreColumns, RaceReadColumns)
    Ruleset2DA = Read2DA(Directory2DA, RulesetFileName, RulesetIgnoreLines, RulesetIgnoreColumns, RulesetReadColumns)
    echo "2DA Reads Complete"
#[
  for i in Class2DA.low .. Class2DA.high:
    echo Class2DA[i]
  for i in Race2DA.low .. Race2DA.high:
    echo Race2DA[i]
  for i in Ruleset2DA.low .. Ruleset2DA.high:
    echo Ruleset2DA[i]
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


proc GetRaceIntModification*(RaceID: int): int =
    for i in Race2DA.low .. Race2DA.high:
        if SafeParseInt2DA(Race2DA[i][RaceColumnRaceID]) == RaceID:
            return SafeParseInt2DA(Race2DA[i][RaceColumnIntMod])
    return 0


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