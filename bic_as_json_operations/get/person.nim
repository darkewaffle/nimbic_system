import std/[json]
import /[string_formatting]

proc GetCharacterFirstName*(CharacterJSON: JsonNode): string
proc GetCharacterLastName*(CharacterJSON: JsonNode): string
proc GetCharacterFullName*(CharacterJSON: JsonNode): string
proc GetCharacterDeity*(CharacterJSON: JsonNode): string

proc GetCharacterGoodEvil*(CharacterJSON: JsonNode): int
proc GetCharacterGoodEvilDescription*(CharacterJSON: JsonNode): string
proc GetCharacterLawfulChaotic*(CharacterJSON: JsonNode): int
proc GetCharacterLawfulChaoticDescription*(CharacterJSON: JsonNode): string


proc GetCharacterFirstName*(CharacterJSON: JsonNode): string =
    return SafeString(CharacterJSON["FirstName"]["value"]["0"].getStr)

proc GetCharacterLastName*(CharacterJSON: JsonNode): string =
    return SafeString(CharacterJSON["LastName"]["value"]["0"].getStr)

proc GetCharacterFullName*(CharacterJSON: JsonNode): string =
    return GetCharacterFirstName(CharacterJSON) & " " & GetCharacterLastName(CharacterJSON)

proc GetCharacterDeity*(CharacterJSON: JsonNode): string =
    return SafeString(CharacterJSON["Deity"]["value"].getStr)

proc GetCharacterGoodEvil*(CharacterJSON: JsonNode): int =
    return CharacterJSON["GoodEvil"]["value"].getInt

proc GetCharacterGoodEvilDescription*(CharacterJSON: JsonNode): string =
    var AlignValue = GetCharacterGoodEvil(CharacterJSON)
    if AlignValue > 75:
        return "Good"
    elif AlignValue < 25:
        return "Evil"
    else:
        return "Neutral"

proc GetCharacterLawfulChaotic*(CharacterJSON: JsonNode): int =
    return CharacterJSON["LawfulChaotic"]["value"].getInt

proc GetCharacterLawfulChaoticDescription*(CharacterJSON: JsonNode): string =
    var AlignValue = GetCharacterLawfulChaotic(CharacterJSON)
    if AlignValue > 75:
        return "Lawful"
    elif AlignValue < 25:
        return "Chaotic"
    else:
        return "Neutral"