import std/[json]

proc CharacterHasRace*(CharacterJSON: JsonNode, RequiredRace: int): bool
proc CharacterHasSubrace*(CharacterJSON: JsonNode, RequiredSubrace: string): bool
proc GetCharacterRace*(CharacterJSON: JsonNode): int
proc GetCharacterSubrace*(CharacterJSON: JsonNode): string

proc CharacterHasRace*(CharacterJSON: JsonNode, RequiredRace: int): bool =
    if CharacterJSON["Race"]["value"].getInt == RequiredRace:
        return true
    else:
        return false

proc CharacterHasSubrace*(CharacterJSON: JsonNode, RequiredSubrace: string): bool =
    if CharacterJSON["Subrace"]["value"].getStr == RequiredSubrace:
        return true
    else:
        return false

proc GetCharacterRace*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Race"]["value"].getInt

proc GetCharacterSubrace*(CharacterJSON: JsonNode): string =
    return CharacterJSON["Subrace"]["value"].getStr