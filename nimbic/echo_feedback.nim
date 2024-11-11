import std/[json, paths, terminal]
from ../bic_as_json_operations/get/person import GetCharacterFullName

proc EchoMessageNamePath*(Message: string, CharacterJSON: JsonNode, FileLocation: Path) =
    echo Message & " - " & GetCharacterFullName(CharacterJSON) & " - " & FileLocation.string

proc EchoMessageNameFilename*(Message: string, CharacterJSON: JsonNode, FileLocation: Path) =
    echo Message & " - " & GetCharacterFullName(CharacterJSON) & " - " & extractFileName(FileLocation).string

proc EchoMessageName*(Message: string, CharacterJSON: JsonNode) =
        echo Message & " - " & GetCharacterFullName(CharacterJSON)

proc EchoBlank*() =
    echo " "

proc EchoLine*() =
    echo " - - - - - - - - - - "

proc EchoSeparator*() =
    EchoBlank()
    EchoLine()
    EchoBlank()

proc EchoWarning*(Message: string) =
    styledEcho fgYellow, "Warning: ", resetStyle, Message

proc EchoError*(Message: string) =
    styledEcho fgRed, "Error: ", resetStyle, Message

proc EchoNotice*(Message: string) =
    styledEcho fgGreen, "Notice: ", resetStyle, Message