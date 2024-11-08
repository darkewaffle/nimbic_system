import std/[json]
import ../nimbic/[echo_feedback]
import ../nimbic/settings/[object_settingspackage]

import add/[feat]
import get/[feats]
from get/classes import GetLvlStatListIndexOfClassLevel

proc AddClassFeat*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage, FirstOrLastPosition: string = "Last")
proc AddLevelFeat*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage, FirstOrLastPosition: string = "Last")
proc AddFeat(CharacterJSON: JsonNode, OperationSettings: SettingsPackage, LvlStatListIndex: int, FirstOrLastPosition: string = "Last")

proc AddClassFeat*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage, FirstOrLastPosition: string = "Last") =
    #Identifies the LvlStatList index where the required level for the class is found. Ensures that the feat is granted to the
    #class at the appropriate level (which is important for 2DA compliance)
    var LvlStatListIndex = GetLvlStatListIndexOfClassLevel(CharacterJSON, OperationSettings.Class, OperationSettings.Level)
    AddFeat(CharacterJSON, OperationSettings, LvlStatListIndex, FirstOrLastPosition)

proc AddLevelFeat*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage, FirstOrLastPosition: string = "Last") =
    #Level will be specified as 1-40 so simply subtracting 1 translates it to index's 0-39 range
    var LvlStatListIndex = OperationSettings.Level - 1
    AddFeat(CharacterJSON, OperationSettings, LvlStatListIndex, FirstOrLastPosition)

proc AddFeat(CharacterJSON: JsonNode, OperationSettings: SettingsPackage, LvlStatListIndex: int, FirstOrLastPosition: string = "Last") =
    InitializeFeatJSONObjects(OperationSettings.Feat)
    AddFeatToLvlStatList(CharacterJSON, LvlStatListIndex, FirstOrLastPosition)

    #Identify the feat that appears previous to the newly added feat within LvlStatList
    var PreviousFeat = GetPreviousFeatInLvlStatList(CharacterJSON, OperationSettings.Feat)
    #Get the FeatList position of the previous feat and then add the new feat to the FeatList in the following position
    var PreviousFeatPosition = GetFeatPositionInFeatList(CharacterJSON, PreviousFeat)
    AddFeatToFeatList(CharacterJSON, PreviousFeatPosition + 1)