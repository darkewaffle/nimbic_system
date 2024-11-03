import std/[strutils, algorithm, streams, json, tables, os, paths, dirs, sequtils]
import std/private/osfiles
import object_settingspackage
import read2da
import io_operations
import character_getters_setters
import html_formatting
import echo_feedback
from ability_modify import AbilityOrder

proc JSONtoHTML*(InputFile: string, OperationSettings: SettingsPackage)
#proc JSONtoHTML*(InputFile: string)
proc BuildBasicsTable(CharacterJSON: JsonNode): string
proc BuildLevelTable(CharacterJSON: JsonNode): string


proc JSONtoHTML*(InputFile: string, OperationSettings: SettingsPackage) =
#proc JSONtoHTML*(InputFile: string) =
    echo "JSON to HTML beginning" & $InputFile

    var CharacterJSON: JsonNode
    CharacterJSON = parseFile(InputFile)

    var BasicsTable = BuildBasicsTable(CharacterJSON)
    var LevelTable = BuildLevelTable(CharacterJSON)

    var FinalHTML = WrapHTML(StyleHeader & WrapBody(BasicsTable & LevelTable))
    writeFile("""C:\Users\jorda\Desktop\test.html""", FinalHTML)
    echo "JSON to HTML complete"


proc BuildBasicsTable(CharacterJSON: JsonNode): string =
    var BasicsTable: seq[array[3, string]]

    BasicsTable.add(BasicsTableColumns1)
    BasicsTable.add([GetCharacterFullName(CharacterJSON), GetRaceLabel(GetCharacterRace(CharacterJSON), true), GetCharacterSubRace(CharacterJSON)])
    BasicsTable.add(BasicsTableColumns2)
    BasicsTable.add([GetCharacterDeity(CharacterJSON), GetCharacterGoodEvilDescription(CharacterJSON), GetCharacterLawfulChaoticDescription(CharacterJSON)])


    var ClassesAndLevels = GetCharacterClasses(CharacterJSON)
    var ClassRow1: array[3, string]
    var ClassRow2: array[3, string]
    var ClassRow3: array[3, string]
    for i in ClassesAndLevels.low .. ClassesAndLevels.high:
        if i <= 2:
            ClassRow1[i] = GetClassLabel(ClassesAndLevels[i][0], true) & " - " & $ClassesAndLevels[i][1]
        elif i >= 3 and i <= 5:
            ClassRow2[i] = GetClassLabel(ClassesAndLevels[i][0], true) & " - " & $ClassesAndLevels[i][1]
        else:
            ClassRow3[i] = GetClassLabel(ClassesAndLevels[i][0], true) & " - " & $ClassesAndLevels[i][1]
    
    BasicsTable.add(ClassRow1)
    if ClassesAndLevels.high >= 3:
        BasicsTable.add(ClassRow2)
    if ClassesAndLevels.high >= 6:
        BasicsTable.add(ClassRow3)

    var BasicsHTML: string
    for i in BasicsTable.low .. BasicsTable.high:
        if i == 0 or i == 2:
            BasicsHTML = BasicsHTML & CreateTableHeader(BasicsTable[i])
        else:
            BasicsHTML = BasicsHTML & CreateTableRow(BasicsTable[i])

    return WrapDiv(WrapTable(BasicsHTML, "basics"))

proc BuildLevelTable(CharacterJSON: JsonNode): string =
    #Level Number, Class, Ability, Feats, Skills

    var LevelHTML = LevelTableHeader
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

        for j in LevelFeats.low .. LevelFeats.high:
            if j != LevelFeats.high:
                LevelData[3] = LevelData[3] & $LevelFeats[j] & """</br>"""
            else:
                LevelData[3] = LevelData[3] & $LevelFeats[j]


        #Skills
        var LevelSkills: seq[array[2, string]]
        var SkillTable = initOrderedTable[string, int]()

        for j in CharacterJSON["LvlStatList"]["value"][i]["SkillList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"][i]["SkillList"]["value"].elems.high:
            var SkillRanksObtained = CharacterJSON["LvlStatList"]["value"][i]["SkillList"]["value"][j]["Rank"]["value"].getInt
            if SkillRanksObtained > 0:
                SkillTable[GetSkillLabel(j, true)] = SkillRanksObtained
                #LevelSkills.add([GetSkillLabel(j), $SkillRanksObtained])

        #sort(LevelSkills)

        #[ for j in LevelSkills.low .. LevelSkills.high:
            if j != LevelSkills.high:
                LevelData[4] = LevelData[4] & $LevelSkills[j][0] & "  -  " & $LevelSkills[j][1] & """</br>"""
            else:
                LevelData[4] = LevelData[4] & $LevelSkills[j][0] & "  -  " & $LevelSkills[j][1] ]#

        SkillTable.sort(system.cmp)

        for key, value in  SkillTable.pairs:
            LevelData[4] = LevelData[4] & key & " - " & $value & """</br>"""
        removeSuffix(LevelData[4], """<\br>""")


        FullLevelData.add(LevelData)

    for i in FullLevelData.low .. FullLevelData.high:
        var RowHTML: string
        for j in FullLevelData[i].low .. FullLevelData[i].high:
            RowHTML = RowHTML & WrapTD(FullLevelData[i][j])
        RowHTML = WrapTR(RowHTML)
        LevelHTML = LevelHTML & RowHTML

    return WrapDiv(WrapTable(LevelHTML, "levels"))