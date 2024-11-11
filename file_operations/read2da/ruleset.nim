import std/[strutils]
import /[reader]

const
    RulesetFileName = "ruleset"
    RulesetIgnoreLines = 10
    RulesetIgnoreColumns = 1
    RulesetReadColumns = 2
    RulesetLabelColumn = 0
    RulesetValueColumn = 1
var
    Ruleset2DA: seq[seq[string]]

proc Read2DA_Ruleset*()
proc GetRulesetValue*(RulesetLabel: string): float

proc Read2DA_Ruleset*() =
    Ruleset2DA = Read2DA(RulesetFileName, RulesetIgnoreLines, RulesetIgnoreColumns, RulesetReadColumns)

proc GetRulesetValue*(RulesetLabel: string): float =
    var RulesetValue: string
    for i in Ruleset2DA.low .. Ruleset2DA.high:
        if Ruleset2DA[i][RulesetLabelColumn] == RulesetLabel:
            RulesetValue = Ruleset2DA[i][RulesetValueColumn]

    if RulesetValue == "":
        return 0.float
    elif RulesetValue == "****":
        return 0.float
    elif count(RulesetValue, "f")>0:
        return parseFloat(replace(RulesetValue, "f", ""))
    else:
        return parseFloat(RulesetValue)