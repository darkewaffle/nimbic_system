import std/[json, strutils]

proc GetCharacterFirstName*(CharacterJSON: JsonNode): string
proc GetCharacterLastName*(CharacterJSON: JsonNode): string
proc GetCharacterFullName*(CharacterJSON: JsonNode): string
proc GetCharacterDeity*(CharacterJSON: JsonNode): string

proc GetCharacterGoodEvil*(CharacterJSON: JsonNode): int
proc GetCharacterGoodEvilDescription*(CharacterJSON: JsonNode): string
proc GetCharacterLawfulChaotic*(CharacterJSON: JsonNode): int
proc GetCharacterLawfulChaoticDescription*(CharacterJSON: JsonNode): string


proc GetCharacterFirstName*(CharacterJSON: JsonNode): string =
    var FirstName = CharacterJSON["FirstName"]["value"]["0"].getStr
    removePrefix(FirstName, " ")
    removeSuffix(FirstName, " ")
    return FirstName

proc GetCharacterLastName*(CharacterJSON: JsonNode): string =
    var LastName = CharacterJSON["LastName"]["value"]["0"].getStr
    removePrefix(LastName, " ")
    removeSuffix(LastName, " ")
    return LastName

proc GetCharacterFullName*(CharacterJSON: JsonNode): string =
    var FullName = GetCharacterFirstName(CharacterJSON) & " " & GetCharacterLastName(CharacterJSON)
    removePrefix(FullName, " ")
    removeSuffix(FullName, " ")
    return FullName

proc GetCharacterDeity*(CharacterJSON: JsonNode): string =
    return CharacterJSON["Deity"]["value"].getStr

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