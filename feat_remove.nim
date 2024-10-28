import std/json
import echo_feedback
import jsonbic_iteration_navigation

proc RemoveClassFeat*(CharacterJSON: JsonNode, RemoveFromClass: int, RemoveFromLevel: int, FeatID: int): bool
proc RemoveLevelFeat*(CharacterJSON: JsonNode, RemoveFromLevel: int, FeatID: int): bool
proc RemoveFeatFromLvlStatList(CharacterJSON: JsonNode, LvlStatListIndex: int, FeatID: int): bool
proc RemoveFeatFromFeatList(CharacterJSON: JsonNode, FeatID: int)
proc RemoveFeatFromQB(CharacterJSON: JsonNode, FeatID: int)
proc RemoveQB(CharacterJSON: JsonNode, QBType: int, QBIdentifier: int)
proc RemoveMetamagicSpellFromQB(CharacterJSON: JsonNode, QBType: int, QBMeta: int)

let
  QBObject_Empty = %*{"__struct_id": 0, "QBObjectType": {"type": "byte", "value": 0}}

const 
  QBType_Feat = 4
  QBType_Skill = 3
  QBType_Spell = 2
  QBType_SpellLike = 44
  MetamagicFeats = [11, 12, 25, 29, 33, 37]
  MetamagicQBMeta = [1, 2, 4, 8, 16, 32]

#[
Metamagic Feats
11 = empower
12 = extend
25 = maximize
29 = quicken
33 = silent
37 = still

QBMeta
1 = empower
2 = extend
4 = maximize
8 = quicken
16 = silence
32 = still
]#


proc RemoveClassFeat*(CharacterJSON: JsonNode, RemoveFromClass: int, RemoveFromLevel: int, FeatID: int): bool =
  var LvlStatListIndex = FindLvlStatListIndexOfClassLevel(CharacterJSON, RemoveFromClass, RemoveFromLevel)
  if RemoveFeatFromLvlStatList(CharacterJSON, LvlStatListIndex, FeatID):
    RemoveFeatFromFeatList(CharacterJSON, FeatID)
    RemoveFeatFromQB(CharacterJSON, FeatID)
    return true
  else:
    EchoMessageName("Feat " & $FeatID & " not found in LvlStatList", CharacterJSON)
    return false


proc RemoveLevelFeat*(CharacterJSON: JsonNode, RemoveFromLevel: int, FeatID: int): bool =
  if RemoveFeatFromLvlStatList(CharacterJSON, RemoveFromLevel - 1, FeatID):
    RemoveFeatFromFeatList(CharacterJSON, FeatID)
    RemoveFeatFromQB(CharacterJSON, FeatID)
    return true
  else:
    EchoMessageName("Feat " & $FeatID & " not found in LvlStatList", CharacterJSON)
    return false


proc RemoveFeatFromLvlStatList(CharacterJSON: JsonNode, LvlStatListIndex: int, FeatID: int): bool =
  for i in CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"].elems.high:
    if CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"][i]["Feat"]["value"].getInt == FeatID:
      CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["FeatList"]["value"].elems.delete(i)
      EchoMessageName("Feat " & $FeatID & " removed from LvlStatList " & $LvlStatListIndex, CharacterJSON)
      return true
  return false


proc RemoveFeatFromFeatList(CharacterJSON: JsonNode, FeatID: int) =
  for i in CharacterJSON["FeatList"]["value"].elems.low .. CharacterJSON["FeatList"]["value"].elems.high:
    if CharacterJSON["FeatList"]["value"][i]["Feat"]["value"].getInt == FeatID:
      CharacterJSON["FeatList"]["value"].elems.delete(i)
      EchoMessageName("Feat " & $FeatID & " removed from FeatList", CharacterJSON)
      break


proc RemoveFeatFromQB(CharacterJSON: JsonNode, FeatID: int) =
  RemoveQB(CharacterJSON, QBType_Feat, FeatID)
  for i in MetamagicFeats.low .. MetamagicFeats.high:
    if FeatID == MetamagicFeats[i]:
      RemoveMetamagicSpellFromQB(CharacterJSON, QBType_Spell, MetamagicQBMeta[i])


proc RemoveQB(CharacterJSON: JsonNode, QBType: int, QBIdentifier: int) =
  for i in CharacterJSON["QBList"]["value"].elems.low .. CharacterJSON["QBList"]["value"].elems.high:
    if CharacterJSON["QBList"]["value"][i]["QBObjectType"]["value"].getInt == QBType:
      if CharacterJSON["QBList"]["value"][i]["QBINTParam1"]["value"].getInt == QBIdentifier:
        CharacterJSON["QBList"]["value"].elems.delete(i)
        CharacterJSON["QBList"]["value"].elems.insert(QBObject_Empty, i)
        EchoMessageName("QB with type " & $QBType & " and ID " & $QBIdentifier & " cleared at index " & $i, CharacterJSON)

proc RemoveMetamagicSpellFromQB(CharacterJSON: JsonNode, QBType: int, QBMeta: int) =
  for i in CharacterJSON["QBList"]["value"].elems.low .. CharacterJSON["QBList"]["value"].elems.high:
    if CharacterJSON["QBList"]["value"][i]["QBObjectType"]["value"].getInt == QBType:
      if CharacterJSON["QBList"]["value"][i]["QBMetaType"]["value"].getInt == QBMeta:
        CharacterJSON["QBList"]["value"].elems.delete(i)
        CharacterJSON["QBList"]["value"].elems.insert(QBObject_Empty, i)
        EchoMessageName("QB with type " & $QBType & " and Metamagic " & $QBMeta & " cleared at index " & $i, CharacterJSON)