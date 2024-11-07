import std/[files, paths, strutils]
import ../nimbic/[echo_feedback]
import ../nimbic/settings/[object_settingspackage]
import read2da/[classes, cls_feat, cls_stat, feat, race_feat, racialtypes, ruleset, skills, spells]
export          classes, cls_feat, cls_stat, feat, race_feat, racialtypes, ruleset, skills, spells
from read2da/reader import Initialize2DAReader

proc Initialize2DAs*(OperationSettings: SettingsPackage)

proc Initialize2DAs*(OperationSettings: SettingsPackage) =
    echo "2DA Reads Initialized"
    Initialize2DAReader(OperationSettings.Input2DA)
    Read2DA_Class()
    Read2DA_Feat()
    Read2DA_Race()
    Read2DA_Ruleset()
    Read2DA_Skill()
    Read2DA_Spell()
    echo "2DA Reads Complete" 