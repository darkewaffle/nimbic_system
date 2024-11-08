import std/[json]
import ../file_operations/[interface_2da]

import get/[classes]
import set/[hp]

const
    RDDClass = 37
    RDDHPFeats = [987, 1044, 1043, 1042]
    RDDHPRules = ["FEAT_DRAGON_HD12",
                                "FEAT_DRAGON_HD10",
                                "FEAT_DRAGON_HD8",
                                "FEAT_DRAGON_HD6"]
var
    #[ RDDHP = [[-1, -1],
                     [-1, -1],
                     [-1, -1],
                     [-1, -1],
                     [-1, -1]] ]#
    RDDHP: array[5, array[2, int]]

proc MaximizeHP*(CharacterJSON: JsonNode): bool
proc InitializeRDDHPLookup*()
proc GetRDDHP(RDDLevel: int): int

proc MaximizeHP*(CharacterJSON: JsonNode): bool =
    var
        LvlStatClass: int
        HPForClassLevel: int
        HPFromClassRolls = 0
        RDDLevel = 0
    
    for i in CharacterJSON["LvlStatList"]["value"].elems.low .. CharacterJSON["LvlStatList"]["value"].elems.high:
        LvlStatClass = GetClassAtLvlStatListIndex(CharacterJSON, i)
        if LvlStatClass != RDDClass:
            HPForClassLevel = GetClassHPPerLevel(LvlStatClass)
        else:
            inc RDDLevel
            HPForClassLevel = GetRDDHP(RDDLevel)
        SetLvlStatListHP(CharacterJSON, i, HPForClassLevel)
        HPFromClassRolls = HPFromClassRolls + HPForClassLevel

    SetHitPoints(CharacterJSON, HPFromClassRolls)
    SetCurrentHitPoints(CharacterJSON, HPFromClassRolls)
    return true

proc InitializeRDDHPLookup*() =
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
            echo $RDDHPFeats[i] & "     " & RDDHPRules[i] & "     " & $RDDHP[i][0] & "     " & $RDDHP[i][1]
        else:
            echo "Level 0 placeholders     " & $RDDHP[i][0] & "     " & $RDDHP[i][1]
 ]#

proc GetRDDHP(RDDLevel: int): int =
    for i in RDDHP.low .. RDDHP.high:
        if RDDLevel >= RDDHP[i][0]:
            return RDDHP[i][1]
