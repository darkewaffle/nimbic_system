import std/[json, paths, terminal]

proc EchoMessageNamePath*(Message: string, CharacterJSON: JsonNode, FileLocation: string) =
  echo Message & " - " & CharacterJSON["FirstName"]["value"]["0"].getStr & " " & CharacterJSON["LastName"]["value"]["0"].getStr & " - " & FileLocation

proc EchoMessageNameFilename*(Message: string, CharacterJSON: JsonNode, FileLocation: string) =
  var FileName = extractFileName(Path FileLocation)
  echo Message & " - " & CharacterJSON["FirstName"]["value"]["0"].getStr & " " & CharacterJSON["LastName"]["value"]["0"].getStr & " - " & $FileName

proc EchoMessageName*(Message: string, CharacterJSON: JsonNode) =
    echo Message & " - " & CharacterJSON["FirstName"]["value"]["0"].getStr & " " & CharacterJSON["LastName"]["value"]["0"].getStr

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