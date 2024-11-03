import std/[json, strutils]

proc CharacterHasClassLevel*(CharacterJSON: JsonNode, RequiredClass: int, RequiredLevel: int): bool
proc CharacterHasClass*(CharacterJSON: JsonNode, RequiredClass: int): bool
proc CharacterHasRace*(CharacterJSON: JsonNode, RequiredRace: int): bool
proc CharacterHasSubrace*(CharacterJSON: JsonNode, RequiredSubrace: string): bool
proc CharacterHasTotalLevel*(CharacterJSON: JsonNode, RequiredLevel: int): bool

proc GetCharacterLevel*(CharacterJSON: JsonNode): int
proc GetCharacterEpicLevels*(CharacterJSON: JsonNode): int
proc GetCharacterConstitution*(CharacterJSON: JsonNode): int
proc GetCharacterIntelligence*(CharacterJSON: JsonNode): int

const
    MaximumPreEpicLevel = 20

proc CharacterHasClassLevel*(CharacterJSON: JsonNode, RequiredClass: int, RequiredLevel: int): bool =
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        if CharacterJSON["ClassList"]["value"][i]["Class"]["value"].getInt == RequiredClass:
            if CharacterJSON["ClassList"]["value"][i]["ClassLevel"]["value"].getInt >= RequiredLevel:
                return true
    return false


proc CharacterHasClass*(CharacterJSON: JsonNode, RequiredClass: int): bool =
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        if CharacterJSON["ClassList"]["value"][i]["Class"]["value"].getInt == RequiredClass:
            return true
    return false

proc CharacterHasFeat*(CharacterJSON: JsonNode, RequiredFeat: int): bool =
    for i in CharacterJSON["FeatList"]["value"].elems.low .. CharacterJSON["FeatList"]["value"].elems.high:
        if CharacterJSON["FeatList"]["value"][i]["Feat"]["value"].getInt == RequiredFeat:
            return true
    return false

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


proc CharacterHasTotalLevel*(CharacterJSON: JsonNode, RequiredLevel: int): bool =
    var CharacterLevel = 0
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        CharacterLevel = CharacterLevel + CharacterJSON["ClassList"]["value"][i]["ClassLevel"]["value"].getInt
    if CharacterLevel >= RequiredLevel:
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
    if EpicLevels < 0:
        return 0
    else:
        return EpicLevels


proc GetCharacterStrength*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Str"]["value"].getInt

proc GetCharacterDexterity*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Dex"]["value"].getInt

proc GetCharacterConstitution*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Con"]["value"].getInt

proc GetCharacterIntelligence*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Int"]["value"].getInt

proc GetCharacterWisdom*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Wis"]["value"].getInt

proc GetCharacterCharisma*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Cha"]["value"].getInt

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

proc GetCharacterRace*(CharacterJSON: JsonNode): int =
    return CharacterJSON["Race"]["value"].getInt

proc GetCharacterSubrace*(CharacterJSON: JsonNode): string =
    return CharacterJSON["Subrace"]["value"].getStr

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

proc GetCharacterClasses*(CharacterJSON: JsonNode): seq[array[2, int]] =
    var ClassesAndLevels: seq[array[2, int]]
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        var ClassID = CharacterJSON["ClassList"]["value"][i]["Class"]["value"].getInt
        var ClassLevel = CharacterJSON["ClassList"]["value"][i]["ClassLevel"]["value"].getInt
        ClassesAndLevels.add [ClassID, ClassLevel]
    return ClassesAndLevels