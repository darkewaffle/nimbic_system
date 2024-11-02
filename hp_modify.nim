import std/json
import read2da
import object_settingspackage

#proc AlterClassHP*(CharacterJSON: JsonNode, ClassID: int, HPChange: int): bool
proc AlterClassHP*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage): bool
proc MaximizeHP*(CharacterJSON: JsonNode): bool
proc SetLvlStatListHP(CharacterJSON: JsonNode, LvlStatListIndex: int, LvlStatHP: int)
proc GetLvlStatListHP(CharacterJSON: JsonNode, LvlStatListIndex: int): int
proc SetHitPoints(CharacterJSON: JsonNode, HitPoints: int)
proc SetCurrentHitPoints(CharacterJSON: JsonNode, HitPoints: int)
proc FillRDDHPLookup*()
proc GetRDDHP(RDDLevel: int): int

const
  RDDClass = 37
  RDDHPFeats = [987, 1044, 1043, 1042]
  RDDHPRules = ["FEAT_DRAGON_HD12",
                "FEAT_DRAGON_HD10",
                "FEAT_DRAGON_HD8",
                "FEAT_DRAGON_HD6"]
var
  RDDHP = [[-1, -1],
           [-1, -1],
           [-1, -1],
           [-1, -1],
           [-1, -1]]


proc AlterClassHP*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage): bool =
  var 
    CurrentLevelHP = 0
    AlteredHP = 0
    HPFromClassRolls = 0
    ChangesMade = false

  for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
    if CharacterJSON["LvlStatList"]["value"][i]["LvlStatClass"]["value"].getInt == OperationSettings.Class:
      CurrentLevelHP = CharacterJSON["LvlStatList"]["value"][i]["LvlStatHitDie"]["value"].getInt
      AlteredHP = CurrentLevelHP + OperationSettings.HPInput
      if AlteredHP < 1:
        SetLvlStatListHP(CharacterJSON, i, 1)
      else:
        SetLvlStatListHP(CharacterJSON, i, AlteredHP)
      ChangesMade = true
    HPFromClassRolls = HPFromClassRolls + GetLvlStatListHP(CharacterJSON, i)

  if ChangesMade:
    SetHitPoints(CharacterJSON, HPFromClassRolls)
    SetCurrentHitPoints(CharacterJSON, HPFromClassRolls)

  return ChangesMade 

#[ 
proc AlterClassHP*(CharacterJSON: JsonNode, ClassID: int, HPChange: int): bool =
  var 
    CurrentLevelHP = 0
    AlteredHP = 0
    HPFromClassRolls = 0
    ChangesMade = false

  for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
    if CharacterJSON["LvlStatList"]["value"][i]["LvlStatClass"]["value"].getInt == ClassID:
      CurrentLevelHP = CharacterJSON["LvlStatList"]["value"][i]["LvlStatHitDie"]["value"].getInt
      AlteredHP = CurrentLevelHP + HPChange
      if AlteredHP < 1:
        SetLvlStatListHP(CharacterJSON, i, 1)
      else:
        SetLvlStatListHP(CharacterJSON, i, AlteredHP)
      ChangesMade = true
    HPFromClassRolls = HPFromClassRolls + GetLvlStatListHP(CharacterJSON, i)

  if ChangesMade:
    SetHitPoints(CharacterJSON, HPFromClassRolls)
    SetCurrentHitPoints(CharacterJSON, HPFromClassRolls)

  return ChangesMade 
]#


proc MaximizeHP*(CharacterJSON: JsonNode): bool =
  var
    LvlStatClass = 255
    HPForClass = 1
    HPFromClassRolls = 0
    RDDLevel = 0
  
  for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
    LvlStatClass = CharacterJSON["LvlStatList"]["value"][i]["LvlStatClass"]["value"].getInt
    if LvlStatClass != RDDClass:
      HPForClass = GetClassHPPerLevel(LvlStatClass)
    else:
      inc RDDLevel
      HPForClass = GetRDDHP(RDDLevel)
    SetLvlStatListHP(CharacterJSON, i, HPForClass)
    HPFromClassRolls = HPFromClassRolls + HPForClass

  SetHitPoints(CharacterJSON, HPFromClassRolls)
  SetCurrentHitPoints(CharacterJSON, HPFromClassRolls)
  return true


proc SetLvlStatListHP(CharacterJSON: JsonNode, LvlStatListIndex: int, LvlStatHP: int) =
  CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["LvlStatHitDie"]["value"] = %LvlStatHP


proc GetLvlStatListHP(CharacterJSON: JsonNode, LvlStatListIndex: int): int =
  return CharacterJSON["LvlStatList"]["value"][LvlStatListIndex]["LvlStatHitDie"]["value"].getInt


proc SetHitPoints(CharacterJSON: JsonNode, HitPoints: int) =
  CharacterJSON["HitPoints"]["value"] = %HitPoints


proc SetCurrentHitPoints(CharacterJSON: JsonNode, HitPoints: int) =
  CharacterJSON["CurrentHitPoints"]["value"] = %HitPoints


proc FillRDDHPLookup*() =
  for i in RDDHPFeats.low .. RDDHPFeats.high:
    RDDHP[i][0] = GetClassFeatLevel(RDDClass, RDDHPFeats[i])

  for i in RDDHPRules.low .. RDDHPRules.high:
    RDDHP[i][1] = GetRulesetValue(RDDHPRules[i]).int

  #Creates level 0 entry using 2DA Class PerLevelHP as a safeguard.
  RDDHP[RDDHP.high][0] = 0
  RDDHP[RDDHP.high][1] = GetClassHPPerLevel(RDDClass)
#[
  for i in RDDHP.low .. RDDHP.high:
    if i < RDDHP.high:
      echo $RDDHPFeats[i] & "   " & RDDHPRules[i] & "   " & $RDDHP[i][0] & "   " & $RDDHP[i][1]
    else:
      echo "Level 0 placeholders   " & $RDDHP[i][0] & "   " & $RDDHP[i][1]
]#

proc GetRDDHP(RDDLevel: int): int =
  for i in RDDHP.low .. RDDHP.high:
    if RDDLevel >= RDDHP[i][0]:
      return RDDHP[i][1]
