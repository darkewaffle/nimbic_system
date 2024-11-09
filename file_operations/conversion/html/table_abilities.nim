import std/[json]

import /[css_generators, html_generators, html_tag_wrappers]
import ../../[interface_2da]
import ../../../nimbic/[echo_feedback]
import ../../../bic_as_json_operations/[interface_get]

const
    AbilityOrder = ["Str", "Dex", "Con", "Int", "Wis", "Cha"]
    TableColumns = ["", "Start", "Levels", "Class", "Feat", "Final"]
    TableClass = "abilities"
    TableStyle = "{flex: 1 0 30%;}"
    THClass = "abilitiesTH"
    THStyle = "{width: 16%;}"
    TableBorderCustomization = "." & TableClass & ", .abilitiesTH1 {border: 0px;}"

proc BuildAbilityTable*(CharacterJSON: JsonNode): string
proc BuildAbilityTableCSS*(): string

proc BuildAbilityTable*(CharacterJSON: JsonNode): string =
    var
        HTML = CreateTableHeader(TableColumns, THClass, true)
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
        var RowValues: array[6, string]
        RowValues[0] = AbilityOrder[i]
        RowValues[1] = $(AbilitiesStart[i] + AbilitiesFromRace[i])
        RowValues[2] = $AbilitiesFromLevels[i]
        RowValues[3] = $AbilitiesFromAllClasses[i]
        RowValues[4] = $AbilitiesFromFeats[i]
        RowValues[5] = $(AbilitiesEnd[i] + AbilitiesFromRace[i] + AbilitiesFromAllClasses[i])
        HTML = HTML & CreateTableRow(RowValues)

    return WrapTable(HTML, TableClass)

proc BuildAbilityTableCSS*(): string =
    return MakeStyleClass(TableClass, TableStyle) & 
           MakeStyleClass(THClass, THStyle) & 
           TableBorderCustomization