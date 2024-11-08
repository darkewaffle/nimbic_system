import std/[json]

import ../nimbic/[echo_feedback]
import ../nimbic/settings/[object_settingspackage]
import get/[classes, hp]
import set/[hp]


proc AlterClassHP*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage): bool

proc AlterClassHP*(CharacterJSON: JsonNode, OperationSettings: SettingsPackage): bool =
    var 
        CurrentLevelHP = 0
        AlteredHP = 0
        HPFromClassRolls = 0
        ChangesMade = false

    for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
        if GetClassAtLvlStatListIndex(CharacterJSON, i) == OperationSettings.Class:
            CurrentLevelHP = GetHPAtLvlStatListIndex(CharacterJSON, i)
            AlteredHP = CurrentLevelHP + OperationSettings.HPInput
            if AlteredHP < 1:
                SetLvlStatListHP(CharacterJSON, i, 1)
            else:
                SetLvlStatListHP(CharacterJSON, i, AlteredHP)
            ChangesMade = true
        HPFromClassRolls = HPFromClassRolls + GetHPAtLvlStatListIndex(CharacterJSON, i)

    if ChangesMade:
        SetHitPoints(CharacterJSON, HPFromClassRolls)
        SetCurrentHitPoints(CharacterJSON, HPFromClassRolls)

    return ChangesMade