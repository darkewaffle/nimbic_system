import std/[dirs, files, paths, strutils]
import ../../nimbic/[echo_feedback]

var Directory2DA: string

proc Initialize2DAReader*(FileDirectory: string)
proc Read2DA*(FileName: string, IgnoreFirstLines: int = 0, IgnoreFirstColumns: int = 0, ColumnsToRead: int = 1): seq[seq[string]]

proc Initialize2DAReader*(FileDirectory: string) =
    Directory2DA = FileDirectory
    #Char(92) = \
    removeSuffix(Directory2DA, char(92))

    if not(dirExists(Path(Directory2DA))):
        EchoError("2DA directory location is undefined or invalid: " & Directory2DA)
        quit(QuitSuccess)

proc Read2DA*(FileName: string, IgnoreFirstLines: int = 0, IgnoreFirstColumns: int = 0, ColumnsToRead: int = 1): seq[seq[string]] =
    var
        CountLines = 0 - IgnoreFirstLines
        FileContents: seq[seq[string]]
        FullPath = Path(Directory2DA) / Path(FileName)

    if not(fileExists(FullPath)):
        EchoError("2DA " & $FullPath & " was not found.")
        quit(QuitSuccess)

    for line in ($FullPath).lines:
        var 
            LineContents: seq[string]
            CountColumns = 0 - IgnoreFirstColumns
        if CountLines < 0:
            discard
        else:
            for item in line.splitWhiteSpace(-1):
                if CountColumns < 0:
                    discard
                elif CountColumns < ColumnsToRead:
                    LineContents.insert(item, CountColumns)
                else:
                    break
                inc CountColumns
            FileContents.add(LineContents)
        inc CountLines

    return FileContents