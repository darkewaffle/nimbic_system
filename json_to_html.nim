import std/[strutils, algorithm, streams, json, tables, os, paths, dirs, sequtils]
import std/private/osfiles
import object_settingspackage
import read2da
import io_operations
import character_getters_setters
import html_formatting
import echo_feedback
from ability_modify import AbilityOrder

type
    LevelTableRow = array[5, string]
    BasicTableRow = array[3, string]

const
    BasicTableColumns1: BasicTableRow = ["Name", "Race", "Subrace"]
    BasicTableColumns2: BasicTableRow = ["Deity", "Good / Evil", "Lawful / Chaotic"]
    BasicTableClass = "basics"
    BasicTableStyle = "." & BasicTableClass & " {width: 50%;}"
    BasicTableTHClass = "basicsTH"
    BasicTableTHStyle = "." & BasicTableTHClass & " {width: 33%;}"

    ClassTableClass = "classes"
    ClassTableTHClass = "classesTH"
 

    LevelTableColumns: LevelTableRow = ["Level", "Class", "Ability", "Feats", "Skills"]
    LevelTableClass = "levels"
    LevelTableStyle = "." & LevelTableClass & " {width: 60%;}"
    LevelTableTHClass = "levelsTH"
    #Dynamically assigned in call to BuildLevelTable > LevelHTML > CreateTableHeader by passing true as third parameter
    LevelTableTHStyle = ".levelsTH1, .levelsTH3 {width: 8%;} .levelsTH2, .levelsTH5 {width: 12%;} .levelsTH4 {width: 60%;}"

    LevelInnerTableClass = "levelinnertable"
    LevelInnerTableStyle = "." & LevelInnerTableClass & " {width: 80%; margin-top: 5px; margin-bottom: 5px;}"
    LevelInnerTableCell = "levelinnercell"
    LevelInnerCellStyle = "." & LevelInnerTableCell & " {width: 50%;}"
    LevelInnerSharedStyle = "." & LevelInnerTableClass & ", ." & LevelInnerTableCell & " {border: 0px solid #ffffff;}"


    HTMLStyleCore = """
    table, th, td {border: 1px solid #535b64; border-collapse: collapse; color: #b9b9b9; margin-top: 30px;}
    th, td {padding: 5px; text-align: center;}
    body {background-color: #000C18;}
    table {margin-left: auto; margin-right: auto;}
    """
    HTMLStyleFull = HTMLStyleCore & BasicTableStyle & BasicTableTHStyle & LevelTableStyle & LevelTableTHStyle & LevelInnerTableStyle & LevelInnerCellStyle & LevelInnerSharedStyle


proc JSONtoHTML*(InputFile: string, OperationSettings: SettingsPackage)
proc BuildBasicTable(CharacterJSON: JsonNode, TableID: int, TableClass: string): string
proc BuildClassTable(CharacterJSON: JsonNode, TableClass: string): string
proc BuildLevelTable(CharacterJSON: JsonNode, TableClass: string): string


proc JSONtoHTML*(InputFile: string, OperationSettings: SettingsPackage) =
    echo "JSON to HTML beginning" & $InputFile

    var 
        CharacterJSON = parseFile(InputFile)

        BasicTable1 = BuildBasicTable(CharacterJSON, 1, BasicTableClass)
        BasicTable2 = BuildBasicTable(CharacterJSON, 2, BasicTableClass)
        ClassTable = BuildClassTable(CharacterJSON, ClassTableClass)
        LevelTable = BuildLevelTable(CharacterJSON, LevelTableClass)

        CharacterNumberOfClasses = GetCharacterClasses(CharacterJSON).high + 1
        DynamicClassWidthStyle = WidthStyle(ClassTableClass, ClassTableTHClass, CharacterNumberOfClasses)

        StyleHeader = WrapHead(WrapStyle(HTMLStyleFull & DynamicClassWidthStyle))
        FinalHTML = WrapHTML(StyleHeader & WrapBody(BasicTable1 & BasicTable2 & ClassTable & LevelTable))

    writeFile("""C:\Users\jorda\Desktop\test.html""", FinalHTML)
    echo "JSON to HTML complete"


proc BuildBasicTable(CharacterJSON: JsonNode, TableID: int, TableClass: string): string =
    var BasicTable: seq[array[3, string]]
    var BasicHTML: string

    case TableID:
        of 1:
            BasicHTML = CreateTableHeader(BasicTableColumns1, BasicTableTHClass)
            BasicTable.add([GetCharacterFullName(CharacterJSON), GetRaceLabel(GetCharacterRace(CharacterJSON), true), GetCharacterSubRace(CharacterJSON)])
        of 2:
            BasicHTML = CreateTableHeader(BasicTableColumns2, BasicTableTHClass)
            BasicTable.add([GetCharacterDeity(CharacterJSON), GetCharacterGoodEvilDescription(CharacterJSON), GetCharacterLawfulChaoticDescription(CharacterJSON)])
        else:
            discard

    for i in BasicTable.low .. BasicTable.high:
        BasicHTML = BasicHTML & CreateTableRow(BasicTable[i])

    return WrapDiv(WrapTable(BasicHTML, TableClass))


proc BuildClassTable(CharacterJSON: JsonNode, TableClass: string): string =
    var 
        ClassesAndLevels = GetCharacterClasses(CharacterJSON)
        ClassTable: seq[string]
        ClassHTML: string

    for i in ClassesAndLevels.low .. ClassesAndLevels.high:
        ClassTable.add(GetClassLabel(ClassesAndLevels[i][0], true) & " - " & $ClassesAndLevels[i][1])

    ClassHTML = ClassHTML & CreateTableRow(ClassTable, ClassTableTHClass)

    return WrapDiv(WrapTable(ClassHTML, TableClass))



proc BuildLevelTable(CharacterJSON: JsonNode, TableClass: string): string =
    #Level Number, Class, Ability, Feats, Skills

    var LevelHTML = CreateTableHeader(LevelTableColumns, LevelTableTHClass, true)
    var FullLevelData: seq[LevelTableRow]

    for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
        var LevelData: LevelTableRow

        #Level number
        LevelData[0] = $(i + 1)

        #Class
        LevelData[1] = GetClassLabel(CharacterJSON["LvlStatList"]["value"][i]["LvlStatClass"]["value"].getInt, true)

        #Ability
        try:
            LevelData[2] = AbilityOrder[CharacterJSON["LvlStatList"]["value"][i]["LvlStatAbility"]["value"].getInt]
        except KeyError:
            LevelData[2] = ""

        #Feats
        var LevelFeats: seq[string]
        try:
            for j in CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"].elems.high:
                LevelFeats.add(GetFeatLabel(CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"][j]["Feat"]["value"].getInt, false))
        except KeyError:
            LevelFeats = @[]

        sort(LevelFeats)
        LevelData[3] = MakeTDTable(LevelFeats, LevelInnerTableClass, LevelInnerTableCell, 2)

        #Skills
        var LevelSkills: seq[array[2, string]]
        var SkillTable = initOrderedTable[string, int]()

        for j in CharacterJSON["LvlStatList"]["value"][i]["SkillList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"][i]["SkillList"]["value"].elems.high:
            var SkillRanksObtained = CharacterJSON["LvlStatList"]["value"][i]["SkillList"]["value"][j]["Rank"]["value"].getInt
            if SkillRanksObtained > 0:
                SkillTable[GetSkillLabel(j, true)] = SkillRanksObtained

        SkillTable.sort(system.cmp)

        var SkillSequence: seq[string]
        for key, value in  SkillTable.pairs:
            SkillSequence.add(key)
            SkillSequence.add("+" & $value)

        LevelData[4] = MakeTDTable(SkillSequence, LevelInnerTableClass, LevelInnerTableCell, 2)

        #Add LevelData 'row' to FullLevelData
        FullLevelData.add(LevelData)

    for i in FullLevelData.low .. FullLevelData.high:
        var RowHTML: string
        for j in FullLevelData[i].low .. FullLevelData[i].high:
            RowHTML = RowHTML & WrapTD(FullLevelData[i][j])
        RowHTML = WrapTR(RowHTML)
        LevelHTML = LevelHTML & RowHTML

    return WrapDiv(WrapTable(LevelHTML, TableClass))