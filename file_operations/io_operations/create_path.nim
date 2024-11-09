import std/[dirs, os, paths, random]

import /[io_constants]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]



proc CreateOutputPath(FileLocation: string, OutputDirectory: string, FileExtension: string, Overwrite: bool = true, OverrideFileName: string = ""): string
proc CreateOutputPathJSON*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true): string
proc CreateOutputPathBIC*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true): string
proc CreateOutputPathSqlite*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true): string
proc CreateOutputPathHTML*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true, OverrideFileName: string = ""): string



proc CreateOutputPath(FileLocation: string, OutputDirectory: string, FileExtension: string, Overwrite: bool = true, OverrideFileName: string = ""): string =
    var SplitPath = splitFile(Path FileLocation)
    var OutputPath = Path(OutputDirectory)
    if not(dirExists(OutputPath)):
        EchoWarning("Path does not exist, attempting to create " & $OutputPath)
        createDir(OutputPath)

    if OverrideFileName != "":
        OutputPath = OutputPath / Path(OverrideFileName)
    else:
        OutputPath = OutputPath / SplitPath.name

    OutputPath = addFileExt(OutputPath, FileExtension)
    if fileExists($OutputPath) and not(Overwrite):
        SplitPath = splitFile(OutputPath)
        randomize()
        var RandomName = $SplitPath.name & "_" & $rand(99999)
        OutputPath = SplitPath.dir / Path(RandomName)
        OutputPath = addFileExt(OutputPath, FileExtension)
    return $OutputPath

proc CreateOutputPathJSON*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true): string =
    return CreateOutputPath(FileLocation, OutputDirectory, ExtensionJSON, Overwrite)

proc CreateOutputPathBIC*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true): string =
    return CreateOutputPath(FileLocation, OutputDirectory, ExtensionBIC, Overwrite)

proc CreateOutputPathSqlite*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true): string =
    return CreateOutputPath(FileLocation, OutputDirectory, ExtensionSQLite, Overwrite)

proc CreateOutputPathHTML*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true, OverrideFileName: string = ""): string =
    return CreateOutputPath(FileLocation, OutputDirectory, ExtensionHTML, Overwrite, OverrideFileName)