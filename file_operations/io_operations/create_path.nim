import std/[dirs, files, paths, random]
import /[io_constants]
import ../../nimbic/[echo_feedback]

proc CreateOutputPath(InputFile: Path, OutputDirectory: Path, FileExtension: string, Overwrite: bool = true, OverrideFileName: string = ""): Path
proc CreateOutputPathJSON*(InputFile: Path, OutputDirectory: Path, Overwrite: bool = true): Path
proc CreateOutputPathBIC*(InputFile: Path, OutputDirectory: Path, Overwrite: bool = true): Path
proc CreateOutputPathSqlite*(InputFile: Path, OutputDirectory: Path, Overwrite: bool = true): Path
proc CreateOutputPathHTML*(InputFile: Path, OutputDirectory: Path, Overwrite: bool = true, OverrideFileName: string = ""): Path

proc CreateOutputPath(InputFile: Path, OutputDirectory: Path, FileExtension: string, Overwrite: bool = true, OverrideFileName: string = ""): Path =
    var 
        InputFileSplit = splitFile(InputFile)
        OutputPath = OutputDirectory

    if not(dirExists(OutputPath)):
        EchoWarning("Path does not exist, attempting to create " & OutputPath.string)
        createDir(OutputPath)

    if OverrideFileName != "":
        OutputPath = OutputPath / Path(OverrideFileName)
    else:
        OutputPath = OutputPath / InputFileSplit.name

    OutputPath = addFileExt(OutputPath, FileExtension)

    if fileExists(OutputPath) and not(Overwrite):
        var OutputPathSplit = splitFile(OutputPath)
        randomize()
        var RandomName = $OutputPathSplit.name & "_" & $rand(99999)
        OutputPath = OutputPathSplit.dir / Path(RandomName)
        OutputPath = addFileExt(OutputPath, FileExtension)

    return OutputPath

proc CreateOutputPathJSON*(InputFile: Path, OutputDirectory: Path, Overwrite: bool = true): Path =
    return CreateOutputPath(InputFile, OutputDirectory, ExtensionJSON, Overwrite)

proc CreateOutputPathBIC*(InputFile: Path, OutputDirectory: Path, Overwrite: bool = true): Path =
    return CreateOutputPath(InputFile, OutputDirectory, ExtensionBIC, Overwrite)

proc CreateOutputPathSqlite*(InputFile: Path, OutputDirectory: Path, Overwrite: bool = true): Path =
    return CreateOutputPath(InputFile, OutputDirectory, ExtensionSQLite, Overwrite)

proc CreateOutputPathHTML*(InputFile: Path, OutputDirectory: Path, Overwrite: bool = true, OverrideFileName: string = ""): Path =
    return CreateOutputPath(InputFile, OutputDirectory, ExtensionHTML, Overwrite, OverrideFileName)