import std/[json]

proc GetHPAtLvlStatListIndex*(CharacterJSON: JsonNode, LvlStatListIndex: int): int
proc GetHitPoints*(CharacterJSON: JsonNode): int
proc GetCurrentHitPoints*(CharacterJSON: JsonNode): int


proc GetHPAtLvlStatListIndex*(CharacterJSON: JsonNode, LvlStatListIndex: int): int =
    return CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["LvlStatHitDie"]["value"].getInt

proc GetHitPoints*(CharacterJSON: JsonNode): int =
    return CharacterJSON["HitPoints"]["value"].getInt

proc GetCurrentHitPoints*(CharacterJSON: JsonNode): int =
    return CharacterJSON["CurrentHitPoints"]["value"].getInt