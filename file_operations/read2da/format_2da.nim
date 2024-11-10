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

    removePrefix(Preparation, ' ')
    removePrefix(Preparation, "FEAT_")
    removePrefix(Preparation, "SKILL_")
    removeSuffix(Preparation, ' ')
    Preparation = Preparation.replace('_', ' ')

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
        var SequentialUppercase = 0
        for i in Preparation.low .. Preparation.high:
            if i == 0:
                Final = capitalizeAscii($Preparation[i])
                inc SequentialUppercase
            else:
                if isDigit(Preparation[i]) or isUpperAscii(Preparation[i]):
                    if isDigit(Preparation[i]):
                        inc SequentialDigits
                        SequentialUppercase = 0
                    elif isUpperAscii(Preparation[i]):
                        SequentialDigits = 0
                        inc SequentialUppercase
                    else:
                        SequentialDigits = 0
                        SequentialUppercase = 0
                    
                    if isDigit(Preparation[i]) and SequentialDigits > 1:
                        Final = Final & Preparation[i]
                    elif isUpperAscii(Preparation[i]) and SequentialUppercase > 1:
                        Final = Final & toLowerAscii(Preparation[i])
                    else:
                        Final = Final & " " & Preparation[i]
                else:
                    Final = Final & Preparation[i]
                    SequentialDigits = 0
                    SequentialUppercase = 0
    return Final

proc ShortenedString*(Input: string): string =
    var
        Shortened: string
        Vowels: set[char] = {'A', 'E', 'I', 'O', 'U', 'a', 'e', 'i', 'o', 'u'}
        ValidCharacters = Letters + Digits - Vowels

    for i in Input.low .. Input.high:
        if Input[i] in ValidCharacters:
            Shortened = Shortened & $Input[i]
    return Shortened