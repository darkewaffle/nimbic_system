import std/[json]
import ../get/[feat]

let
    FeatJSON_LvlStatList = %*{"__struct_id": 0,"Feat": {"type": "word", "value": nil}}
    FeatJSON_FeatList = %*{"__struct_id": 1,"Feat": {"type": "word", "value": nil}}


proc InitializeFeatJSONObjects*(FeatID: int)
proc AddFeatToLvlStatList*(CharacterJSON: JsonNode, LvlStatListIndex: int, FirstOrLastPosition: string = "Last")
proc AddFeatToFeatList*(CharacterJSON: JsonNode, Position: int)


proc InitializeFeatJSONObjects*(FeatID: int) = 
    FeatJSON_LvlStatList["Feat"]["value"] = %FeatID
    FeatJSON_FeatList["Feat"]["value"] = %FeatID

proc AddFeatToLvlStatList*(CharacterJSON: JsonNode, LvlStatListIndex: int, FirstOrLastPosition: string = "Last") =
    var InsertIndex: int
    if FirstOrLastPosition == "First":
        InsertIndex = 0
    elif FirstOrLastPosition == "Last":
        InsertIndex = GetLastPositionInFeatsForLevel(CharacterJSON, LvlStatListIndex) + 1
    else:
        echo "Invalid index specified for AddFeatToLvlStatList"
        return
    CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"].elems.insert(FeatJSON_LvlStatList, InsertIndex)

proc AddFeatToFeatList*(CharacterJSON: JsonNode, Position: int) =
    CharacterJSON["FeatList"]["value"].elems.insert(FeatJSON_FeatList, Position)