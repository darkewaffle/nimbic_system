import std/json

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


proc GetCharacterConstitution*(CharacterJSON: JsonNode): int =
  return CharacterJSON["Con"]["value"].getInt


proc GetCharacterIntelligence*(CharacterJSON: JsonNode): int =
  return CharacterJSON["Int"]["value"].getInt