import std/[json]
import ../get/[abilities]


proc SetCharacterStrength*(CharacterJSON: JsonNode, NewValue: int)
proc SetCharacterDexterity*(CharacterJSON: JsonNode, NewValue: int)
proc SetCharacterConstitution*(CharacterJSON: JsonNode, NewValue: int)
proc SetCharacterIntelligence*(CharacterJSON: JsonNode, NewValue: int)
proc SetCharacterWisdom*(CharacterJSON: JsonNode, NewValue: int)
proc SetCharacterCharisma*(CharacterJSON: JsonNode, NewValue: int)
proc SetCharacterAbilities*(CharacterJSON: JsonNode, NewValues: array[6, int])

proc AlterCharacterStrength*(CharacterJSON: JsonNode, AlterAmount: int)
proc AlterCharacterDexterity*(CharacterJSON: JsonNode, AlterAmount: int)
proc AlterCharacterConstitution*(CharacterJSON: JsonNode, AlterAmount: int)
proc AlterCharacterIntelligence*(CharacterJSON: JsonNode, AlterAmount: int)
proc AlterCharacterWisdom*(CharacterJSON: JsonNode, AlterAmount: int)
proc AlterCharacterCharisma*(CharacterJSON: JsonNode, AlterAmount: int)

proc ValidateAbilityScore(Input: int): int


proc SetCharacterStrength*(CharacterJSON: JsonNode, NewValue: int) =
    CharacterJSON["Str"]["value"] = %ValidateAbilityScore(NewValue)

proc SetCharacterDexterity*(CharacterJSON: JsonNode, NewValue: int) =
    CharacterJSON["Dex"]["value"] = %ValidateAbilityScore(NewValue)

proc SetCharacterConstitution*(CharacterJSON: JsonNode, NewValue: int) =
    CharacterJSON["Con"]["value"] = %ValidateAbilityScore(NewValue)

proc SetCharacterIntelligence*(CharacterJSON: JsonNode, NewValue: int) =
    CharacterJSON["Int"]["value"] = %ValidateAbilityScore(NewValue)

proc SetCharacterWisdom*(CharacterJSON: JsonNode, NewValue: int) =
    CharacterJSON["Wis"]["value"] = %ValidateAbilityScore(NewValue)

proc SetCharacterCharisma*(CharacterJSON: JsonNode, NewValue: int) =
    CharacterJSON["Cha"]["value"] = %ValidateAbilityScore(NewValue)

proc SetCharacterAbilities*(CharacterJSON: JsonNode, NewValues: array[6, int]) =
    SetCharacterStrength(CharacterJSON, NewValues[0])
    SetCharacterDexterity(CharacterJSON, NewValues[1])
    SetCharacterConstitution(CharacterJSON, NewValues[2])
    SetCharacterIntelligence(CharacterJSON, NewValues[3])
    SetCharacterWisdom(CharacterJSON, NewValues[4])
    SetCharacterCharisma(CharacterJSON, NewValues[5])


proc AlterCharacterStrength*(CharacterJSON: JsonNode, AlterAmount: int) =
    SetCharacterStrength(CharacterJSON, GetCharacterStrength(CharacterJSON) + AlterAmount)

proc AlterCharacterDexterity*(CharacterJSON: JsonNode, AlterAmount: int) =
    SetCharacterDexterity(CharacterJSON, GetCharacterDexterity(CharacterJSON) + AlterAmount)

proc AlterCharacterConstitution*(CharacterJSON: JsonNode, AlterAmount: int) =
    SetCharacterConstitution(CharacterJSON, GetCharacterConstitution(CharacterJSON) + AlterAmount)

proc AlterCharacterIntelligence*(CharacterJSON: JsonNode, AlterAmount: int) =
    SetCharacterIntelligence(CharacterJSON, GetCharacterIntelligence(CharacterJSON) + AlterAmount)

proc AlterCharacterWisdom*(CharacterJSON: JsonNode, AlterAmount: int) =
    SetCharacterWisdom(CharacterJSON, GetCharacterWisdom(CharacterJSON) + AlterAmount)

proc AlterCharacterCharisma*(CharacterJSON: JsonNode, AlterAmount: int) =
    SetCharacterCharisma(CharacterJSON, GetCharacterCharisma(CharacterJSON) + AlterAmount)

proc AlterCharacterAbilities*(CharacterJSON: JsonNode, AlterAmounts: array[6, int]) =
    AlterCharacterStrength(CharacterJSON, AlterAmounts[0])
    AlterCharacterDexterity(CharacterJSON, AlterAmounts[1])
    AlterCharacterConstitution(CharacterJSON, AlterAmounts[2])
    AlterCharacterIntelligence(CharacterJSON, AlterAmounts[3])
    AlterCharacterWisdom(CharacterJSON, AlterAmounts[4])
    AlterCharacterCharisma(CharacterJSON, AlterAmounts[5])

proc ValidateAbilityScore(Input: int): int =
    if Input < 3:
        return 3
    if Input > 100:
        return 100
    else:
        return Input