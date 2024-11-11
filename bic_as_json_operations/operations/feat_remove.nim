import std/[json]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]

import ../remove/[feat, quickbar]
from ../get/class import GetLvlStatListIndexOfClassLevel

proc RemoveClassFeat*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage): bool
proc RemoveLevelFeat*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage): bool
proc RemoveFeat(CharacterJSON: JsonNode, OperationSettings: SettingsPackage, LvlStatListIndex: int): bool

proc RemoveClassFeat*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage): bool =
    #Identifies the LvlStatList index where the required level for the class is found. Ensures that the feat is remove from the
    #class at the appropriate level (which is important for 2DA compliance and making sure the feat is not incorrectly removed
    #if the character selected it while gaining normal feats)
    var LvlStatListIndex = GetLvlStatListIndexOfClassLevel(CharacterJSON, OperationSettings.Class, OperationSettings.Level)
    return RemoveFeat(CharacterJSON, OperationSettings, LvlStatListIndex)

proc RemoveLevelFeat*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage): bool =
    #Level will be specified as 1-40 so simply subtracting 1 translates it to index's 0-39 range
    var LvlStatListIndex = OperationSettings.Level - 1
    return RemoveFeat(CharacterJSON, OperationSettings, LvlStatListIndex)

proc RemoveFeat(CharacterJSON: JsonNode, OperationSettings: SettingsPackage, LvlStatListIndex: int): bool =
    if RemoveFeatFromLvlStatList(CharacterJSON, LvlStatListIndex, OperationSettings.Feat):
        RemoveFeatFromFeatList(CharacterJSON, OperationSettings.Feat)
        RemoveFeatFromQB(CharacterJSON, OperationSettings.Feat)
        return true
    else:
        EchoWarning("Feat " & $OperationSettings.Feat & " not found")
        return false