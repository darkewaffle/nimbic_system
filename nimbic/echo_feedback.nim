import std/[terminal]

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

proc EchoSuccess*(Message: string) = 
    styledEcho fgBlue, "Success: ", resetStyle, Message