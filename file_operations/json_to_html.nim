import std/[algorithm, dirs, json, os, paths, sequtils, streams, strutils, tables]

import /[html_formatting, io_operations, read2da]
import ../nimbic/[echo_feedback]
import ../nimbic/settings/[object_settingspackage]
import ../json_operations/[character_getters_setters]
from ../json_operations/ability_modify import AbilityOrder

type
    LevelTableRow = array[5, string]
    BasicTableRow = array[3, string]
    AbilityTableRow = array[6, string]

const
    #1001 = "Epic Character"
    FeatsToIgnore = toSeq([1001])

    FullPageContainer = "pagecontainer"
    CoreStructureCSS = """
        /*  Structural Elements  */
        * {  box-sizing: border-box; }
        html, body, .pagecontainer {width: 100%; background-color: #00101F; margin: 0px; padding: 0px;}
        .pagecontainer {width: 75%;}
        body {padding: 50px;}
        .pagecontainer{display: flex; flex-direction: row; flex-wrap: wrap; gap: 30px 40px; margin: auto;}
        """
    CoreAppearanceCSS = """
        /*  Visual Style  */
        span, table {font-family: Helvetica, Verdana, Tahoma, sans-serif; font-size: 1em; text-align: center; color: #B4ADB4;}
        table, th, td {border: 2px dotted #696267; border-collapse: collapse;}
        td, th {padding: 3px;}
        """

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

    BasicTableColumns1: BasicTableRow = ["Name", "Race", "Subrace"]
    BasicTableColumns2: BasicTableRow = ["Deity", "Good / Evil", "Lawful / Chaotic"]
    BasicTableClass = "basics"
    BasicTableStyle = "{flex: 1 0 auto;}"
    BasicTableTHClass = "basicsTH"
    BasicTableTHStyle = "{width: 33%;}"

    ClassTableClass = "classes"
    ClassTableStyle = "{flex: 1 0 auto;}"
    ClassTableTDClass = "classesTD"

    BasicClassContainer = "basics_and_classes"
    BasicClassContainerStyle = "{flex: 1 0 60%; display: flex; flex-direction: column; row-gap: 40px;}"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

    AbilityTableColumns: AbilityTableRow = ["", "Start", "Levels", "Class", "Feat", "Final"]
    AbilityTableClass = "abilitytable"
    AbilityTableStyle = "{flex: 1 0 30%;}"
    AbilityTableTHClass = "abilityTH"
    AbilityTableTHStyle = "{width: 16%;}"
    AbilityTableBorderCustomization = "." & AbilityTableClass & ", .abilityTH1 {border: 0px;}"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

    LevelTableColumns: LevelTableRow = ["Level", "Class", "Ability", "Feats", "Skills"]
    LevelTableClass = "levels"
    LevelTableStyle = "{width: 100%; margin: auto; flex: 1 0 auto;}"
    LevelTableTHClass = "levelsTH"
    #Unique levelsTH classes assigned in call to BuildLevelTable > LevelHTML > CreateTableHeader by passing true as third parameter to customize width
    LevelTableTHStyle = ".levelsTH1{width: 9%;}  .levelsTH2{width: 12%;}  .levelsTH3{width: 9%;}  .levelsTH4{width: 40%;}  .levelsTH5{width: 30%;}"

    LevelFeatTableClass = "levelfeattable"
    LevelFeatTableStyle = "{margin: auto; width: 80%; border: 0px;}"
    LevelFeatTableCell = "levelfeatcell"
    LevelFeatCellStyle = "{width: 50%; border: 0px;}"

    LevelSkillTableClass = "levelskilltable"
    LevelSkillTableStyle = "{margin: auto; width: 80%; border: 0px;}"
    LevelSkillTableCell = "levelskillcell"
    LevelSkillCellStyle = "{border: 0px; padding: 5px; width: 33%;}"
    #LevelSkillTableCustomization = "." & LevelSkillTableCell & ":nth-child(odd){text-align: right; width: 25%;} ." & LevelSkillTableCell & ":nth-child(even){text-align: left; width: 8%;}"
    LevelSkillTableCustomization = ""

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

    SpellbookContainer = "spellbook"
    SpellbookContainerStyle = "{flex: 1 1 100%; display: flex; flex-direction: row; flex-wrap: wrap; gap: 20px 40px;}"
    SpellbookTitleClass = "spellbookheader"
    SpellbookTitleStyle = " {flex: 1 1 100%; border-bottom: 2px dotted #696267;}"
    SpellbookTableClass = "spellbooktbl"
    SpellbookTableStyle = "{flex:1 1 15%; margin-bottom: auto; border: 0px;}"
    SpellbookCellClass = "spellbookcell"
    SpellbookCellStyle = "{border-left: 0px; border-top: 0px; border-right: 0px;}"



let
    BasicTableCSS = MakeStyleClass(BasicTableClass, BasicTableStyle) & MakeStyleClass(BasicTableTHClass, BasicTableTHStyle)
    ClassTableCSS = MakeStyleClass(ClassTableClass, ClassTableStyle)
    BasicClassContainerCSS = MakeStyleClass(BasicClassContainer, BasicClassContainerStyle)
    AbilityTableCSS = MakeStyleClass(AbilityTableClass, AbilityTableStyle) & MakeStyleClass(AbilityTableTHClass, AbilityTableTHStyle) & AbilityTableBorderCustomization
    LevelTableCSS = MakeStyleClass(LevelTableClass, LevelTableStyle) & LevelTableTHStyle
    LevelFeatCSS = MakeStyleClass(LevelFeatTableClass, LevelFeatTableStyle) & MakeStyleClass(LevelFeatTableCell, LevelFeatCellStyle)
    LevelSkillCSS = MakeStyleClass(LevelSkillTableClass, LevelSkillTableStyle) & MakeStyleClass(LevelSkillTableCell, LevelSkillCellStyle) & LevelSkillTableCustomization
    SpellbookCSS = MakeStyleClass(SpellbookContainer, SpellbookContainerStyle) & MakeStyleClass(SpellbookTitleClass, SpellbookTitleStyle) & MakeStyleClass(SpellbookTableClass, SpellbookTableStyle) & MakeStyleClass(SpellbookCellClass, SpellbookCellStyle)
    FullCSS = CoreStructureCSS & CoreAppearanceCSS & BasicTableCSS & ClassTableCSS & BasicClassContainerCSS & AbilityTableCSS & LevelTableCSS & LevelFeatCSS & LevelSkillCSS & SpellbookCSS


proc JSONtoHTML*(InputFile: string, OperationSettings: SettingsPackage)
proc BuildBasicTable(CharacterJSON: JsonNode, TableID: int, TableClass: string): string
proc BuildClassTable(CharacterJSON: JsonNode, TableClass: string): string
proc BuildAbilityTable(CharacterJSON: JsonNode, TableClass: string): string
proc BuildLevelTable(CharacterJSON: JsonNode, TableClass: string, ShowAllFeats: bool = false): string
proc BuildSpellbookTable(CharacterJSON: JsonNode, Container: string): string
proc SpellbookColumnName(SpellLevel: int): string


proc JSONtoHTML*(InputFile: string, OperationSettings: SettingsPackage) =
    echo "JSON to HTML beginning" & $InputFile

    var
        CharacterJSON = parseFile(InputFile)

        BasicTable1 = BuildBasicTable(CharacterJSON, 1, BasicTableClass)
        BasicTable2 = BuildBasicTable(CharacterJSON, 2, BasicTableClass)
        ClassTable = BuildClassTable(CharacterJSON, ClassTableClass)
        TopLeftTableContainer = WrapDiv(BasicTable1 & BasicTable2 & ClassTable, BasicClassContainer)

        AbilityTable = BuildAbilityTable(CharacterJSON, AbilityTableClass)

        LevelTable = BuildLevelTable(CharacterJSON, LevelTableClass)

        Spellbook = BuildSpellbookTable(CharacterJSON, SpellbookContainer)

        PageContainer = WrapDiv(TopLeftTableContainer & AbilityTable & LevelTable & Spellbook, FullPageContainer)

        CharacterNumberOfClasses = GetCharacterClasses(CharacterJSON).high + 1
        DynamicClassWidthStyle = WidthStyle(ClassTableClass, ClassTableTDClass, CharacterNumberOfClasses)

        StyleHeader = WrapHead(WrapStyle(FullCSS & DynamicClassWidthStyle))
        FinalHTML = WrapHTML(StyleHeader & WrapBody(PageContainer))

    var WritePath = CreateOutputPathHTML(InputFile, OperationSettings.OutputHTML, true)
    writeFile(WritePath, FinalHTML)
    
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

    return WrapTable(BasicHTML, TableClass)

proc BuildClassTable(CharacterJSON: JsonNode, TableClass: string): string =
    var 
        ClassesAndLevels = GetCharacterClasses(CharacterJSON)
        ClassTable: seq[string]
        ClassHTML: string

    for i in ClassesAndLevels.low .. ClassesAndLevels.high:
        ClassTable.add(GetClassLabel(ClassesAndLevels[i][0], true) & " - " & $ClassesAndLevels[i][1])

    ClassHTML = ClassHTML & CreateTableRow(ClassTable, ClassTableTDClass)

    return WrapTable(ClassHTML, TableClass)

proc BuildAbilityTable(CharacterJSON: JsonNode, TableClass: string): string =
    var
        AbilityHTML = CreateTableHeader(AbilityTableColumns, AbilityTableTHClass, true)
        AbilitiesStart = GetCharacterAbilityScoresStart(CharacterJSON)
        AbilitiesFromRace = GetRaceAbilityModifiers(GetCharacterRace(CharacterJSON))
        AbilitiesFromLevels = GetCharacterAbilityIncreaseFromLevels(CharacterJSON)
        AbilitiesFromFeats = GetCharacterAbilityIncreaseFromGreatFeats(CharacterJSON)
        AbilitiesEnd = GetCharacterAbilityScoresCurrent(CharacterJSON)

        AbilitiesFromAllClasses = [0, 0, 0, 0, 0, 0]
        ClassesAndLevels = GetCharacterClasses(CharacterJSON)

    for i in ClassesAndLevels.low .. ClassesAndLevels.high:
        var ClassAbilities = GetClassAbilityModifiers(ClassesAndLevels[i][0], ClassesAndLevels[i][1])
        for i in ClassAbilities.low .. ClassAbilities.high:
            AbilitiesFromAllClasses[i] = AbilitiesFromAllClasses[i] + ClassAbilities[i]

    for i in AbilityOrder.low .. AbilityOrder.high:
        var RowValues: AbilityTableRow
        RowValues[0] = AbilityOrder[i]
        RowValues[1] = $(AbilitiesStart[i] + AbilitiesFromRace[i])
        RowValues[2] = $AbilitiesFromLevels[i]
        RowValues[3] = $AbilitiesFromAllClasses[i]
        RowValues[4] = $AbilitiesFromFeats[i]
        RowValues[5] = $(AbilitiesEnd[i] + AbilitiesFromRace[i] + AbilitiesFromAllClasses[i])
        AbilityHTML = AbilityHTML & CreateTableRow(RowValues)
    
    return WrapTable(AbilityHTML, TableClass)

proc BuildLevelTable(CharacterJSON: JsonNode, TableClass: string, ShowAllFeats: bool = false): string =
    #Level Number, Class, Ability, Feats, Skills

    var LevelHTML = CreateTableHeader(LevelTableColumns, LevelTableTHClass, true)
    var FullLevelData: seq[LevelTableRow]
    var ClassLevelTracker = inittable[int, int]()

    for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
        var LevelData: LevelTableRow

        #Level number
        LevelData[0] = $(i + 1)

        #Class
        var ClassForThisLevel = CharacterJSON["LvlStatList"]["value"][i]["LvlStatClass"]["value"].getInt
        LevelData[1] = GetClassLabel(ClassForThisLevel, true)
        if ClassLevelTracker.hasKey(ClassForThisLevel):
            inc ClassLevelTracker[ClassForThisLevel]
        else:
            ClassLevelTracker[ClassForThisLevel] = 1

        #Ability
        try:
            LevelData[2] = AbilityOrder[CharacterJSON["LvlStatList"]["value"][i]["LvlStatAbility"]["value"].getInt]
        except KeyError:
            LevelData[2] = ""

        #Feats

        var LevelFeats: seq[string]
        var FeatsGrantedAutomatically = concat(GetClassFeatsAtLevel(ClassForThisLevel, ClassLevelTracker[ClassForThisLevel]), FeatsToIgnore)
        try:
            for j in CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"].elems.high:
                var SelectedFeat = CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"][j]["Feat"]["value"].getInt
                if ShowAllFeats:
                    LevelFeats.add(GetFeatLabel(SelectedFeat, true))
                else:
                    if i == 0:
                        FeatsGrantedAutomatically = concat(FeatsGrantedAutomatically, GetRaceFeats(GetCharacterRace(CharacterJSON)))
                    if SelectedFeat in FeatsGrantedAutomatically:
                        discard
                    else:
                        LevelFeats.add(GetFeatLabel(SelectedFeat, true))

        except KeyError:
            LevelFeats = @[]

        sort(LevelFeats)
        LevelData[3] = MakeTDTable(LevelFeats, LevelFeatTableClass, LevelFeatTableCell, 2, false)

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
            SkillSequence.add(key & " +" & $value)
            #SkillSequence.add("+" & $value)

        LevelData[4] = MakeTDTable(SkillSequence, LevelSkillTableClass, LevelSkillTableCell, 3, false)

        #Add LevelData 'row' to FullLevelData
        FullLevelData.add(LevelData)

    for i in FullLevelData.low .. FullLevelData.high:
        var RowHTML: string
        for j in FullLevelData[i].low .. FullLevelData[i].high:
            RowHTML = RowHTML & WrapTD(FullLevelData[i][j])
        RowHTML = WrapTR(RowHTML)
        LevelHTML = LevelHTML & RowHTML

    return WrapTable(LevelHTML, TableClass)

proc BuildSpellbookTable(CharacterJSON: JsonNode, Container: string): string =
    var
        ClassesAndLevels = GetCharacterClasses(CharacterJSON)
        SpellbookHTML: string

    for i in ClassesAndLevels.low .. ClassesAndLevels.high:
        if GetClassSpellbookRestricted(ClassesAndLevels[i][0]):
            var ClassSpellBook = WrapSpan(GetClassLabel(ClassesAndLevels[i][0]) & " Spellbook", SpellbookTitleClass)
            var ClassSpells = GetCharacterSpellsFromClassAsNames(CharacterJSON, ClassesAndLevels[i][0])
            for j in ClassSpells.low .. ClassSpells.high:
                var LevelSpells = ClassSpells[j]
                LevelSpells.insert(SpellbookColumnName(j), 0)
                ClassSpellBook = ClassSpellBook & MakeTDTable(LevelSpells, SpellbookTableClass, SpellbookCellClass, 1, false)
            SpellbookHTML = SpellbookHTML & ClassSpellBook

    return WrapDiv(SpellbookHTML, Container)

proc SpellbookColumnName(SpellLevel: int): string =
    if SpellLevel > 0:
        return "Level " & $SpellLevel
    else:
        return "Cantrips"