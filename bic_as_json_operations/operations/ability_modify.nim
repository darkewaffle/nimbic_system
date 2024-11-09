import std/[json, strutils]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]
import ../set/[abilities]


proc ModifyAbilities*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage)
proc SetAbilities*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage)
proc AbilityIndex*(Input: string): int

proc ModifyAbilities*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage) =
    AlterCharacterAbilities(CharacterJSON, OperationSettings.AbilityInput)

proc SetAbilities*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage) =
    SetCharacterAbilities(CharacterJSON, OperationSettings.AbilityInput)

#Ability order verified that 0..5 correspond to LvlStatList > LvlStatAbility values
const AbilityOrder* = ["Str", "Dex", "Con", "Int", "Wis", "Cha"]
const AbilityOrderLong* = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"]

proc AbilityIndex*(Input: string): int =
    var FormattedInput = capitalizeAscii(toLowerAscii(Input))
    for i in AbilityOrder.low .. AbilityOrder.high:
        if AbilityOrder[i] == FormattedInput or AbilityOrderLong[i] == FormattedInput:
            return i
    return 0