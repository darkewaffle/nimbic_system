import std/json
import echo_feedback
import jsonbic_iteration_navigation

proc AddClassFeat*(CharacterJSON: JsonNode, AddToClass: int, AddToLevel: int, FeatID: int, FirstOrLastPosition: string = "Last")
proc AddLevelFeat*(CharacterJSON: JsonNode, AddToLevel: int, FeatID: int, FirstOrLastPosition: string = "Last")

proc AddFeatToLvlStatList(CharacterJSON: JsonNode, LvlStatListIndex: int, FirstOrLastPosition: string = "Last")
proc AddFeatToFeatList(CharacterJSON: JsonNode, AfterFeatID: int)
proc AssignFeatIDToJObjects(FeatID: int)

let 
  FeatJSON_LvlStatList = %*{"__struct_id": 0,"Feat": {"type": "word", "value": nil}}
  FeatJSON_FeatList = %*{"__struct_id": 1,"Feat": {"type": "word", "value": nil}}

proc AddClassFeat*(CharacterJSON: JsonNode, AddToClass: int, AddToLevel: int, FeatID: int, FirstOrLastPosition: string = "Last") =
  AssignFeatIDToJObjects(FeatID)
  var LvlStatListIndex = FindLvlStatListIndexOfClassLevel(CharacterJSON, AddToClass, AddToLevel)
  AddFeatToLvlStatList(CharacterJSON, LvlStatListIndex, FirstOrLastPosition)
  var PreviousFeat = FindPreviousFeatInFeatList(CharacterJSON, FeatID)
  AddFeatToFeatList(CharacterJSON, PreviousFeat)


proc AddLevelFeat*(CharacterJSON: JsonNode, AddToLevel: int, FeatID: int, FirstOrLastPosition: string = "Last") =
  AssignFeatIDToJObjects(FeatID)
  AddFeatToLvlStatList(CharacterJSON, AddToLevel - 1, FirstOrLastPosition)
  var PreviousFeat = FindPreviousFeatInFeatList(CharacterJSON, FeatID)
  AddFeatToFeatList(CharacterJSON, PreviousFeat)


proc AddFeatToLvlStatList(CharacterJSON: JsonNode, LvlStatListIndex: int, FirstOrLastPosition: string = "Last") =
  var InsertIndex: int
  if FirstOrLastPosition == "First":
    InsertIndex = 0
  elif FirstOrLastPosition == "Last":
    InsertIndex = CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"].elems.high + 1
  else:
    echo "Invalid index specified for AddFeatToLvlStatList"
    return
  CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"].elems.insert(FeatJSON_LvlStatList, InsertIndex)
  EchoMessageName(Message="Feat " & $FeatJSON_LvlStatList["Feat"]["value"].getInt & " added to LvlStatList " & $LvlStatListIndex & " at position " & $InsertIndex, CharacterJSON)


proc AddFeatToFeatList(CharacterJSON: JsonNode, AfterFeatID: int) =
  for i in CharacterJSON["FeatList"]["value"].elems.low .. CharacterJSON["FeatList"]["value"].elems.high:
    if CharacterJSON["FeatList"]["value"][i]["Feat"]["value"].getInt == AfterFeatID:
      CharacterJSON["FeatList"]["value"].elems.insert(FeatJSON_FeatList, i+1)
      EchoMessageName(Message="Feat " & $FeatJSON_FeatList["Feat"]["value"].getInt & " added to FeatList at position " & $(i+1) & " after feat " & $AfterFeatID, CharacterJSON)
      break


proc AssignFeatIDToJObjects(FeatID: int) = 
  FeatJSON_LvlStatList["Feat"]["value"] = %FeatID
  FeatJSON_FeatList["Feat"]["value"] = %FeatID
