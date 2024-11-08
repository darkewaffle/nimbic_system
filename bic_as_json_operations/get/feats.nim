import std/[json]

proc CharacterHasFeat*(CharacterJSON: JsonNode, RequiredFeat: int): bool
proc GetFeatInFeatListPosition*(CharacterJSON: JsonNode, ListPosition: int): int
proc GetFeatPositionInFeatList*(CharacterJSON: JsonNode, FeatID: int): int
proc GetFeatInLvlStatListFeatList*(CharacterJSON: JsonNode, LvlStatListIndex: int, FeatListIndex: int): int 
proc GetLastPositionInFeatsForLevel*(CharacterJSON: JsonNode, LvlStatListIndex: int): int
proc GetPreviousFeatInLvlStatList*(CharacterJSON: JsonNode, FeatID: int): int

proc CharacterHasFeat*(CharacterJSON: JsonNode, RequiredFeat: int): bool =
    for i in CharacterJSON["FeatList"]["value"].elems.low .. CharacterJSON["FeatList"]["value"].elems.high:
        if CharacterJSON["FeatList"]["value"][i]["Feat"]["value"].getInt == RequiredFeat:
            return true
    return false

proc GetFeatInFeatListPosition*(CharacterJSON: JsonNode, ListPosition: int): int =
    return CharacterJSON["FeatList"]["value"][ListPosition]["Feat"]["value"].getInt

proc GetFeatPositionInFeatList*(CharacterJSON: JsonNode, FeatID: int): int =
    for i in CharacterJSON["FeatList"]["value"].elems.low .. CharacterJSON["FeatList"]["value"].elems.high:
        if CharacterJSON["FeatList"]["value"][i]["Feat"]["value"].getInt == FeatID:
            return i
    return -1

proc GetFeatInLvlStatListFeatList*(CharacterJSON: JsonNode, LvlStatListIndex: int, FeatListIndex: int): int =
    return CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"][FeatListIndex]["Feat"]["value"].getInt

proc GetLastPositionInFeatsForLevel*(CharacterJSON: JsonNode, LvlStatListIndex: int): int =
    return CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"].elems.high

proc GetPreviousFeatInLvlStatList*(CharacterJSON: JsonNode, FeatID: int): int =
    var PreviousFeat = -1
    for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
        for j in CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"].elems.high:
            if CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"][j]["Feat"]["value"].getInt == FeatID:
                return PreviousFeat
            else:
                PreviousFeat = CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"][j]["Feat"]["value"].getInt
    return PreviousFeat