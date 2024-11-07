import std/[strutils]

proc SafeParseInt2DA*(Input: string): int
proc PrettyString*(Input: string): string

proc SafeParseInt2DA*(Input: string): int =
    if Input == "****":
        return 0
    else:
        return parseInt(Input)

proc PrettyString*(Input: string): string =
    var 
        Preparation = Input
        WordContainer: string
        Final: string

    removePrefix(Preparation, " ")
    removePrefix(Preparation, "FEAT_")
    removeSuffix(Preparation, " ")
    Preparation = Preparation.replace("_", " ")

    if contains(Preparation, " "):
        Preparation = toLower(Preparation)

        for i in Preparation.low .. Preparation.high:

            if not(isSpaceAscii(Preparation[i])):
                WordContainer = WordContainer & Preparation[i]
            else:
                WordContainer = capitalizeAscii(WordContainer)
                Final = Final & WordContainer & " "
                WordContainer = ""

            if i == Preparation.high:
                WordContainer = capitalizeAscii(WordContainer)
                Final = Final & WordContainer
    else:
        var SequentialDigits = 0
        for i in Preparation.low .. Preparation.high:
            if i == 0:
                Final = capitalizeAscii($Preparation[i])
            else:
                if isUpperAscii(Preparation[i]) or isDigit(Preparation[i]):
                    if isDigit(Preparation[i]):
                        inc SequentialDigits
                    else:
                        SequentialDigits = 0
                    if isDigit(Preparation[i]) and SequentialDigits > 1:
                        Final = Final & Preparation[i]
                    else:
                        Final = Final & " " & Preparation[i]
                else:
                    Final = Final & Preparation[i]
    return Final