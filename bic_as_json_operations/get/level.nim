import std/[json]

const
    MaximumPreEpicLevel = 20

proc CharacterHasTotalLevel*(CharacterJSON: JsonNode, RequiredLevel: int): bool
proc GetCharacterLevel*(CharacterJSON: JsonNode): int
proc GetCharacterEpicLevels*(CharacterJSON: JsonNode): int

proc CharacterHasTotalLevel*(CharacterJSON: JsonNode, RequiredLevel: int): bool =
    if GetCharacterLevel(CharacterJSON) >= RequiredLevel:
        return true
    else:
        return false

proc GetCharacterLevel*(CharacterJSON: JsonNode): int =
    var CharacterLevel = 0
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        CharacterLevel = CharacterLevel + CharacterJSON["ClassList"]["value"][i]["ClassLevel"]["value"].getInt
    return CharacterLevel

proc GetCharacterEpicLevels*(CharacterJSON: JsonNode): int =
    var EpicLevels = GetCharacterLevel(CharacterJSON) - MaximumPreEpicLevel
    if EpicLevels <= 0:
        return 0
    else:
        return EpicLevels