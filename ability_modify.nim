import std/[json, strutils]
import echo_feedback
import object_settingspackage

#proc ModifyAbilities*(CharacterJSON: JsonNode, AbilityModifications: array[0..5, int])
proc ModifyAbilities*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage)
proc ValidateAbilityScore(Input: int): int 
proc AbilityIndex*(Input: string): int
proc EchoModifications(AbilityModifications: array[0..5, int])

#Ability order verified that 0..5 correspond to LvlStatList > LvlStatAbility values
const AbilityOrder* = ["Str", "Dex", "Con", "Int", "Wis", "Cha"]
const AbilityOrderLong* = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"]


proc ModifyAbilities*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage) =
    var AbilityResult: int
    var AbilityModifications = OperationSettings.AbilityInput
    for i in AbilityModifications.low .. AbilityModifications.high:
        AbilityResult = AbilityModifications[i] + CharacterJSON[AbilityOrder[i]]["value"].getInt
        AbilityResult = ValidateAbilityScore(AbilityResult)
        EchoMessageName(AbilityOrder[i] & " was = " & $CharacterJSON[AbilityOrder[i]]["value"].getInt & ", changed by " & $AbilityModifications[i] & " and set to " & $AbilityResult, CharacterJSON)
        CharacterJSON[AbilityOrder[i]]["value"] = %AbilityResult

#[ 
proc ModifyAbilities*(CharacterJSON: JsonNode, AbilityModifications: array[0..5, int]) =
    var AbilityResult: int
    for i in AbilityModifications.low .. AbilityModifications.high:
        AbilityResult = AbilityModifications[i] + CharacterJSON[AbilityOrder[i]]["value"].getInt
        AbilityResult = ValidateAbilityScore(AbilityResult)
        EchoMessageName(AbilityOrder[i] & " was = " & $CharacterJSON[AbilityOrder[i]]["value"].getInt & ", changed by " & $AbilityModifications[i] & " and set to " & $AbilityResult, CharacterJSON)
        CharacterJSON[AbilityOrder[i]]["value"] = %AbilityResult
]#


proc ValidateAbilityScore(Input: int): int =
    if Input < 3:
        return 3
    if Input > 100:
        return 100
    else:
        return Input


proc AbilityIndex*(Input: string): int =
    var FormattedInput = capitalizeAscii(toLowerAscii(Input))
    for i in AbilityOrder.low .. AbilityOrder.high:
        if AbilityOrder[i] == FormattedInput or AbilityOrderLong[i] == FormattedInput:
            return i
    return 0


proc EchoModifications(AbilityModifications: array[0..5, int]) =
    for i in AbilityModifications.low .. AbilityModifications.high:
        echo AbilityOrder[i] & " - " & $AbilityModifications[i]