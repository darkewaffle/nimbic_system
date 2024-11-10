import std/[dirs, files, paths, strutils]
import ../../nimbic/[echo_feedback]

const Extension2DA = "2da"
var Directory2DA: Path

proc Initialize2DAReader*(FileDirectory: Path)
proc Read2DA*(FileName: string, IgnoreFirstLines: int = 0, IgnoreFirstColumns: int = 0, ColumnsToRead: int = 1): seq[seq[string]]

proc Initialize2DAReader*(FileDirectory: Path) =
    Directory2DA = FileDirectory
    if not(dirExists(Directory2DA)):
        EchoError("2DA access is required for this operation and the 2DA directory location is undefined or invalid: " & Directory2DA.string)
        quit(QuitSuccess)

proc Read2DA*(FileName: string, IgnoreFirstLines: int = 0, IgnoreFirstColumns: int = 0, ColumnsToRead: int = 1): seq[seq[string]] =
    var
        CountLines = 0 - IgnoreFirstLines
        FileContents: seq[seq[string]]
        FullPath = Directory2DA / Path(FileName)
    FullPath = FullPath.addFileExt(Extension2DA)

    if not(fileExists(FullPath)):
        EchoError("2DA " & FullPath.string & " was not found.")
        quit(QuitSuccess)

    for line in (FullPath.string).lines:
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