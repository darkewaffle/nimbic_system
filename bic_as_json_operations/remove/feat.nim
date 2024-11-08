import std/[json]

proc RemoveFeatFromLvlStatList*(CharacterJSON: JsonNode, LvlStatListIndex: int, FeatID: int): bool
proc RemoveFeatFromFeatList*(CharacterJSON: JsonNode, FeatID: int)

proc RemoveFeatFromLvlStatList*(CharacterJSON: JsonNode, LvlStatListIndex: int, FeatID: int): bool =
    for i in CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"].elems.high:
        if CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"][i]["Feat"]["value"].getInt == FeatID:
            CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"].elems.delete(i)
            return true
    return false

proc RemoveFeatFromFeatList*(CharacterJSON: JsonNode, FeatID: int) =
    for i in CharacterJSON["FeatList"]["value"].elems.low .. CharacterJSON["FeatList"]["value"].elems.high:
        if CharacterJSON["FeatList"]["value"][i]["Feat"]["value"].getInt == FeatID:
            CharacterJSON["FeatList"]["value"].elems.delete(i)
            break