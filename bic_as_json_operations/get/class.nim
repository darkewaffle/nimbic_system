import std/[json]

proc CharacterHasClassLevel*(CharacterJSON: JsonNode, RequiredClass: int, RequiredLevel: int): bool
proc CharacterHasClass*(CharacterJSON: JsonNode, RequiredClass: int): bool
proc GetCharacterClasses*(CharacterJSON: JsonNode): seq[array[2, int]]
proc GetClassAtLvlStatListIndex*(CharacterJSON: JsonNode, LvlStatListIndex: int): int
proc GetLvlStatListIndexOfClassLevel*(CharacterJSON: JsonNode, ClassID: int, LevelRequired: int): int

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

proc GetCharacterClasses*(CharacterJSON: JsonNode): seq[array[2, int]] =
    var ClassesAndLevels: seq[array[2, int]]
    for i in CharacterJSON["ClassList"]["value"].elems.low .. CharacterJSON["ClassList"]["value"].elems.high:
        var ClassID = CharacterJSON["ClassList"]["value"][i]["Class"]["value"].getInt
        var ClassLevel = CharacterJSON["ClassList"]["value"][i]["ClassLevel"]["value"].getInt
        ClassesAndLevels.add [ClassID, ClassLevel]
    return ClassesAndLevels

proc GetClassAtLvlStatListIndex*(CharacterJSON: JsonNode, LvlStatListIndex: int): int =
    return CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["LvlStatClass"]["value"].getInt

proc GetLvlStatListIndexOfClassLevel*(CharacterJSON: JsonNode, ClassID: int, LevelRequired: int): int =
    var LevelsInClass = 0
    for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
        if CharacterJSON["LvlStatList"]["value"][i]["LvlStatClass"]["value"].getInt == ClassID:
            inc LevelsInClass
        if LevelsInClass == LevelRequired:
            return i
    return -1