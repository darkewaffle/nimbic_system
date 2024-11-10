import std/[paths]

proc SeqStringToSeqPath*(Input: seq[string]): seq[Path]
proc SeqPathToSeqString*(Input: seq[Path]): seq[string]

proc SeqStringToSeqPath*(Input: seq[string]): seq[Path] =
    var Output: seq[Path]
    for i in Input.low .. Input.high:
        Output.add(Path(Input[i]))
    return Output

proc SeqPathToSeqString*(Input: seq[Path]): seq[string] =
    var Output: seq[string]
    for i in Input.low .. Input.high:
        Output.add(Input[i].string)
    return Output