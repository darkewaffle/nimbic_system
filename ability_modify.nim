import std/[json, strutils]
import echo_feedback

proc ModifyAbilities*(CharacterJSON: JsonNode, AbilityModifications: array[0..5, int])
proc ValidateAbilityScore(Input: int): int 
proc AbilityIndex*(Input: string): int
proc EchoModifications(AbilityModifications: array[0..5, int])

#Ability order verified that 0..5 correspond to LvlStatList > LvlStatAbility values
const AbilityOrder = ["Str", "Dex", "Con", "Int", "Wis", "Cha"]
const GreatIntFeats = [794 .. 803]


proc ModifyAbilities*(CharacterJSON: JsonNode, AbilityModifications: array[0..5, int]) =
  var AbilityResult: int
  for i in AbilityModifications.low .. AbilityModifications.high:
    AbilityResult = AbilityModifications[i] + CharacterJSON[AbilityOrder[i]]["value"].getInt
    AbilityResult = ValidateAbilityScore(AbilityResult)
    EchoMessageName(AbilityOrder[i] & " was = " & $CharacterJSON[AbilityOrder[i]]["value"].getInt & ", changed by " & $AbilityModifications[i] & " and set to " & $AbilityResult, CharacterJSON)
    CharacterJSON[AbilityOrder[i]]["value"] = %AbilityResult


proc ValidateAbilityScore(Input: int): int =
  if Input < 3:
    return 3
  if Input > 100:
    return 100
  else:
    return Input


proc AbilityIndex*(Input: string): int =
  for i in AbilityOrder.low .. AbilityOrder.high:
    if AbilityOrder[i] == capitalizeAscii(toLowerAscii(Input)):
      return i
  return 0


proc EchoModifications(AbilityModifications: array[0..5, int]) =
  for i in AbilityModifications.low .. AbilityModifications.high:
    echo AbilityOrder[i] & " - " & $AbilityModifications[i]