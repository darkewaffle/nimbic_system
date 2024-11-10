import std/[strutils]

proc SafeString*(Input: string, RemoveSpaces: bool = true): string

proc SafeString*(Input: string, RemoveSpaces: bool = true): string =
    var 
        Output: string
        InvalidCharacters = PunctuationChars
    
    if RemoveSpaces:
        InvalidCharacters = InvalidCharacters + {' '}

    for i in Input.low .. Input.high:
        if Input[i] in InvalidCharacters:
            discard
        else:
            Output = Output & $Input[i]
    return Output