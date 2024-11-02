import std/json


proc FindLvlStatListIndexOfClassLevel*(CharacterJSON: JsonNode, ClassID: int, LevelRequired: int): int =
    var LevelsInClass = 0
    for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
        if CharacterJSON["LvlStatList"]["value"][i]["LvlStatClass"]["value"].getInt == ClassID:
            inc LevelsInClass
        if LevelsInClass == LevelRequired:
            return i
    return -1


proc FindPreviousFeatInFeatList*(CharacterJSON: JsonNode, FeatID: int): int =
    var PreviousFeat = -1
    for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
        for j in CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"].elems.high:
            if CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"][j]["Feat"]["value"].getInt == FeatID:
                echo "Previous feat identified " & $PreviousFeat
                return PreviousFeat
            else:
                PreviousFeat = CharacterJSON["LvlStatList"]["value"][i]["FeatList"]["value"][j]["Feat"]["value"].getInt
    return PreviousFeat