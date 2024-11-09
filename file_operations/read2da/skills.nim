import /[reader, format_2da]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]

const
    SkillFileName = "skills.2da"
    SkillIgnoreLines = 3
    SkillIgnoreColumns = 0
    SkillReadColumns = 2
    SkillColumnSkillID = 0
    SkillColumnSkillLabel = 1
var
    Skill2DA: seq[seq[string]]

proc Read2DA_Skill*()
proc GetSkillLabel*(SkillID: int, Pretty: bool = false): string

proc Read2DA_Skill*() =
    Skill2DA = Read2DA(SkillFileName, SkillIgnoreLines, SkillIgnoreColumns, SkillReadColumns)

proc GetSkillLabel*(SkillID: int, Pretty: bool = false): string =
    for i in Skill2DA.low .. Skill2DA.high:
        if SafeParseInt2DA(Skill2DA[i][SkillColumnSkillID]) == SkillID:
            if not(Pretty):
                return Skill2DA[i][SkillColumnSkillLabel]
            else:
                return PrettyString(Skill2DA[i][SkillColumnSkillLabel])
    return ""