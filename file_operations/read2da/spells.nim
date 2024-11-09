import /[reader, format_2da]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]

const
#spells.2da
    SpellFileName = "spells.2da"
    SpellIgnoreLines = 3
    SpellIgnoreColumns = 0
    SpellReadColumns = 2
    SpellColumnSpellID = 0
    SpellColumnSpellLabel = 1
var
    Spell2DA: seq[seq[string]]

proc Read2DA_Spell*()
proc GetSpellLabel*(SpellID: int, Pretty: bool = true): string

proc Read2DA_Spell*() =
    Spell2DA = Read2DA(SpellFileName, SpellIgnoreLines, SpellIgnoreColumns, SpellReadColumns)

proc GetSpellLabel*(SpellID: int, Pretty: bool = true): string =
    for i in Spell2DA.low .. Spell2DA.high:
        if SafeParseInt2DA(Spell2DA[i][SpellColumnSpellID]) == SpellID:
            if not(Pretty):
                return Spell2DA[i][SpellColumnSpellLabel]
            else:
                return PrettyString(Spell2DA[i][SpellColumnSpellLabel])
    return ""