import std/[json]
import ../get/[hp]

proc SetLvlStatListHP*(CharacterJSON: JsonNode, LvlStatListIndex: int, NewValue: int)
proc AlterLvlStatListHP*(CharacterJSON: JsonNode, LvlStatListIndex: int, AlterAmount: int)
proc SetHitPoints*(CharacterJSON: JsonNode, HitPoints: int)
proc SetCurrentHitPoints*(CharacterJSON: JsonNode, HitPoints: int)

proc SetLvlStatListHP*(CharacterJSON: JsonNode, LvlStatListIndex: int, NewValue: int) =
    CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["LvlStatHitDie"]["value"] = %NewValue

proc AlterLvlStatListHP*(CharacterJSON: JsonNode, LvlStatListIndex: int, AlterAmount: int) =
    SetLvlStatListHP(CharacterJSON, LvlStatListIndex, GetHPAtLvlStatListIndex(CharacterJSON, LvlStatListIndex) + AlterAmount)

proc SetHitPoints*(CharacterJSON: JsonNode, HitPoints: int) =
    CharacterJSON["HitPoints"]["value"] = %HitPoints

proc SetCurrentHitPoints*(CharacterJSON: JsonNode, HitPoints: int) =
    CharacterJSON["CurrentHitPoints"]["value"] = %HitPoints