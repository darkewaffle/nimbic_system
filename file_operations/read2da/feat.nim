import /[reader, format_2da]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]

const
    FeatFileName = "feat.2da"
    FeatIgnoreLines = 3
    FeatIgnoreColumns = 0
    FeatReadColumns = 2
    FeatColumnFeatID = 0
    FeatColumnFeatLabel = 1
var
    Feat2DA: seq[seq[string]]

proc Read2DA_Feat*() 
proc GetFeatLabel*(FeatID: int, Pretty: bool = false): string

proc Read2DA_Feat*() =
    Feat2DA = Read2DA(FeatFileName, FeatIgnoreLines, FeatIgnoreColumns, FeatReadColumns)

proc GetFeatLabel*(FeatID: int, Pretty: bool = false): string =
    for i in Feat2DA.low .. Feat2DA.high:
        if SafeParseInt2DA(Feat2DA[i][FeatColumnFeatID]) == FeatID:
            if not(Pretty):
                return Feat2DA[i][FeatColumnFeatLabel]
            else:
                return PrettyString(Feat2DA[i][FeatColumnFeatLabel])
    return ""