import std/[algorithm, json, sequtils, strutils, tables]

import /[html_formatting]
import ../../[io_operations, interface_2da]
import ../../../nimbic/[echo_feedback]
import ../../../nimbic/settings/[object_settingspackage]
import ../../../bic_as_json_operations/[interface_get]
from ../../../bic_as_json_operations/ability_modify import AbilityOrder

type
    LevelTableRow = array[5, string]

const
    #1001 = "Epic Character"
    FeatsToIgnore = toSeq([1001])

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
    LevelSkillTableCustomization = ""

let
    LevelTableCSS* = MakeStyleClass(LevelTableClass, LevelTableStyle) & LevelTableTHStyle
    LevelFeatCSS* = MakeStyleClass(LevelFeatTableClass, LevelFeatTableStyle) & MakeStyleClass(LevelFeatTableCell, LevelFeatCellStyle)
    LevelSkillCSS* = MakeStyleClass(LevelSkillTableClass, LevelSkillTableStyle) & MakeStyleClass(LevelSkillTableCell, LevelSkillCellStyle) & LevelSkillTableCustomization


proc BuildLevelTable*(CharacterJSON: JsonNode, TableClass: string, ShowAutomaticFeats: bool = false): string


proc BuildLevelTable*(CharacterJSON: JsonNode, TableClass: string, ShowAutomaticFeats: bool = false): string =
    #Level Number, Class, Ability, Feats, Skills

    var LevelHTML = CreateTableHeader(LevelTableColumns, LevelTableTHClass, true)
    var FullLevelData: seq[LevelTableRow]
    var ClassLevelTracker = inittable[int, int]()

    for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
        var LevelData: LevelTableRow

        #Level number
        LevelData[0] = $(i + 1)

        #Class
        var ClassForThisLevel = GetClassAtLvlStatListIndex(CharacterJSON, i)
        LevelData[1] = GetClassLabel(ClassForThisLevel, true)
        if ClassLevelTracker.hasKey(ClassForThisLevel):
            inc ClassLevelTracker[ClassForThisLevel]
        else:
            ClassLevelTracker[ClassForThisLevel] = 1

        #Ability
        LevelData[2] = GetCharacterAbilityIncreaseAtLvlStatListIndex(CharacterJSON, i)


        #Feats
        #var SelectedFeat = CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"][j]["Feat"]["value"].getInt

        var LevelFeats: seq[string]
        var FeatsGrantedAutomatically = concat(GetClassFeatsAtLevel(ClassForThisLevel, ClassLevelTracker[ClassForThisLevel]), FeatsToIgnore)
        for j in CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"].elems.high:
            var SelectedFeat = GetFeatInLvlStatListFeatList(CharacterJSON, i, j)
            if ShowAutomaticFeats:
                LevelFeats.add(GetFeatLabel(SelectedFeat, true))
            else:
                #If this is the first level then add feats granted by character race to the automatic list.
                if i == 0:
                    FeatsGrantedAutomatically = concat(FeatsGrantedAutomatically, GetRaceFeats(GetCharacterRace(CharacterJSON)))
                if SelectedFeat in FeatsGrantedAutomatically:
                    discard
                else:
                    LevelFeats.add(GetFeatLabel(SelectedFeat, true))

        sort(LevelFeats)
        LevelData[3] = MakeTDTable(LevelFeats, LevelFeatTableClass, LevelFeatTableCell, 2, false)

        #Skills
        var LevelSkills: seq[array[2, string]]
        var SkillTable = initOrderedTable[string, int]()

        for j in CharacterJSON["LvlStatList"]["value"][i]["SkillList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"][i]["SkillList"]["value"].elems.high:
            #var SkillRanksObtained = CharacterJSON["LvlStatList"]["value"][i]["SkillList"]["value"][j]["Rank"]["value"].getInt
            var SkilLRanksObtained = GetSkillRanksObtainedInLvlStatList(CharacterJSON, i, j)
            if SkillRanksObtained > 0:
                SkillTable[GetSkillLabel(j, true)] = SkillRanksObtained

        SkillTable.sort(system.cmp)

        var SkillSequence: seq[string]
        for key, value in  SkillTable.pairs:
            SkillSequence.add(key & " +" & $value)

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