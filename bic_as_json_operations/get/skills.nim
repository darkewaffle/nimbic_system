import std/[json]

proc GetSkillRanksObtainedInLvlStatList*(CharacterJSON: JsonNode, LvLStatListIndex: int, SkillID: int): int

proc GetSkillRanksObtainedInLvlStatList*(CharacterJSON: JsonNode, LvLStatListIndex: int, SkillID: int): int =
    return CharacterJSON["LvlStatList"]["value"][LvLStatListIndex]["SkillList"]["value"][SkillID]["Rank"]["value"].getInt