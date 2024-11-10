import std/[algorithm, json, sequtils, tables]

import /[css_generators, html_generators, html_tag_wrappers]
import ../../[interface_2da]
import ../../../nimbic/[echo_feedback]
import ../../../bic_as_json_operations/[interface_get]

const
    #1001 = "Epic Character"
    FeatsToIgnore = toSeq([1001])

    TableColumns= ["Level", "Class", "Ability", "Feats", "Skills"]
    TableClass = "levels"
    TableStyle = "{width: 100%; margin: auto; flex: 1 0 auto;}"
    THClass = "levelsTH"
    #Unique levelsTH classes assigned in call to BuildTable > LevelHTML > CreateTableHeader by passing true as third parameter to customize width
    THStyle = ".levelsTH1{width: 9%;}  .levelsTH2{width: 12%;}  .levelsTH3{width: 9%;}  .levelsTH4{width: 25%;}  .levelsTH5{width: 45%;}"

    FeatTableClass = "feattable"
    FeatTableStyle = "{margin: auto; width: 90%; border: 0px;}"
    FeatTableCell = "featcell"
    FeatCellStyle = "{width: 50%; border: 0px;}"

    SkillTableClass = "skilltable"
    SkillTableStyle = "{margin: auto; width: 90%; border: 0px;}"
    SkillTableCell = "skillcell"
    SkillCellStyle = "{border: 0px; padding: 5px; min-width: 20%;}"

proc BuildLevelTable*(CharacterJSON: JsonNode, ShowAutomaticFeats: bool = false): string
proc BuildLevelTableCSS*(): string

proc BuildLevelTable*(CharacterJSON: JsonNode, ShowAutomaticFeats: bool = false): string =
    #Level Number, Class, Ability, Feats, Skills

    var LevelHTML = CreateTableHeader(TableColumns, THClass, true)
    var FullLevelData: seq[array[5, string]]
    var ClassLevelTracker = inittable[int, int]()

    for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
        var LevelData: array[5, string]

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
                LevelFeats.add(GetFeatConstant(SelectedFeat, true))
            else:
                #If this is the first level then add feats granted by character race to the automatic list.
                if i == 0:
                    FeatsGrantedAutomatically = concat(FeatsGrantedAutomatically, GetRaceFeats(GetCharacterRace(CharacterJSON)))
                if SelectedFeat in FeatsGrantedAutomatically:
                    discard
                else:
                    LevelFeats.add(GetFeatConstant(SelectedFeat, true))

        sort(LevelFeats)
        LevelData[3] = MakeTDTable(LevelFeats, FeatTableClass, FeatTableCell, 2, false)

        #Skills
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

        LevelData[4] = MakeTDTable(SkillSequence, SkillTableClass, SkillTableCell, 4, false)

        #Add LevelData 'row' to FullLevelData
        FullLevelData.add(LevelData)

    for i in FullLevelData.low .. FullLevelData.high:
        var RowHTML: string
        for j in FullLevelData[i].low .. FullLevelData[i].high:
            RowHTML = RowHTML & WrapTD(FullLevelData[i][j])
        RowHTML = WrapTR(RowHTML)
        LevelHTML = LevelHTML & RowHTML

    return WrapTable(LevelHTML, TableClass)

proc BuildLevelTableCSS*(): string =
    return MakeStyleClass(TableClass, TableStyle) & 
           MakeStyleClass(THClass, THStyle) & 
           MakeStyleClass(FeatTableClass, FeatTableStyle) &
           MakeStyleClass(FeatTableCell, FeatCellStyle) &
           MakeStyleClass(SkillTableClass, SkillTableStyle) &
           MakeStyleClass(SkillTableCell, SkillCellStyle)