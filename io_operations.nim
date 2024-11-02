import std/[algorithm, dirs, os, paths, sequtils, strutils, times]
import echo_feedback
import object_settingspackage

proc GetFilesByPattern(DirectoryPath: string, ReadSubdirectories: bool, FileTypePattern: string): seq[string]
#proc GetBICFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string]
#proc GetJSONFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string]
proc GetBICFiles*(OperationSettings: SettingsPackage): seq[string]
proc GetJSONFiles*(OperationSettings: SettingsPackage): seq[string]

proc CreateOutputPath(FileLocation: string, OutputDirectory: string, FileExtension: string): string
proc CreateOutputPathJSON*(FileLocation: string, OutputDirectory: string): string
proc CreateOutputPathBIC*(FileLocation: string, OutputDirectory: string): string
proc CreateOutputPathSqlite*(FileLocation: string, OutputDirectory: string): string

proc ReplaceFileExtension*(FileLocation: string, NewExtension: string): string
proc SetFileExtensionJSON*(FileLocation: string): string
proc SetFileExtensionBIC*(FileLocation: string): string
proc SetFileExtensionSqlite*(FileLocation: string): string

proc GetSubdirectoriesByPattern(ParentDirectory: string, SearchPattern: string): seq[string]
proc GetSubdirectoriesAll(ParentDirectory: string): seq[string]
proc GetSubdirectoriesBackup(ParentDirectory: string): seq[string]

proc TimestampString(): string

const
    BackupDirectoryPrefix = """BIC_Backup_"""
    ExtensionJSON* = """.json"""
    ExtensionBIC* = """.bic"""
    ExtensionSQLite* = """.sqlite3"""
    PatternExtensionJSON = """\*""" & ExtensionJSON
    PatternExtensionBIC = """\*""" & ExtensionBIC
    PatternExtensionSQlite = """\*""" & ExtensionSQLite
    PatternSubdirectoriesAll = """\*"""
    PatternSubdirectoriesBackup = """\""" & BackupDirectoryPrefix & """*"""

let
    OperationTimestamp* = TimestampString()
    BackupDirectoryFullName* = BackupDirectoryPrefix & OperationTimestamp

proc GetFilesByPattern(DirectoryPath: string, ReadSubdirectories: bool, FileTypePattern: string): seq[string] =
    var DirectoriesToSearch: seq[string]
    var SearchPattern: string
    var FileResults: seq[string]

    if ReadSubdirectories:
        DirectoriesToSearch = GetSubdirectoriesAll(DirectoryPath)
    else:
        DirectoriesToSearch.add(DirectoryPath)

    for i in DirectoriesToSearch.low .. DirectoriesToSearch.high:
        SearchPattern = DirectoriesToSearch[i] & FileTypePattern
        echo "Searching for " & SearchPattern
        FileResults = concat(FileResults, toSeq(walkPattern(SearchPattern)))

    return FileResults


proc GetBICFiles*(OperationSettings: SettingsPackage): seq[string] =
        GetFilesByPattern(OperationSettings.InputBIC, OperationSettings.ReadSubdirectories, PatternExtensionBIC)

proc GetJSONFiles*(OperationSettings: SettingsPackage): seq[string] =
        GetFilesByPattern(OperationSettings.InputJSON, OperationSettings.ReadSubdirectories, PatternExtensionJSON)
#[
proc GetBICFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string] =
    GetFilesByPattern(DirectoryPath, PatternExtensionBIC, ReadSubdirectories)

proc GetJSONFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string] =
    GetFilesByPattern(DirectoryPath, PatternExtensionJSON, ReadSubdirectories)
]#

proc CreateOutputPath(FileLocation: string, OutputDirectory: string, FileExtension: string): string =
    var SplitPath = splitFile(Path FileLocation)
    var OutputPath = Path(OutputDirectory)
    if not(dirExists(OutputPath)):
        EchoWarning("Path does not exist, attempting to create " & $OutputPath)
        createDir(OutputPath)
    OutputPath = OutputPath / SplitPath.name
    OutputPath = addFileExt(OutputPath, FileExtension)
    return $OutputPath

proc CreateOutputPathJSON*(FileLocation: string, OutputDirectory: string): string =
    return CreateOutputPath(FileLocation, OutputDirectory, ExtensionJSON)

proc CreateOutputPathBIC*(FileLocation: string, OutputDirectory: string): string =
    return CreateOutputPath(FileLocation, OutputDirectory, ExtensionBIC)

proc CreateOutputPathSqlite*(FileLocation: string, OutputDirectory: string): string =
    return CreateOutputPath(FileLocation, OutputDirectory, ExtensionSQLite)

proc ReplaceFileExtension*(FileLocation: string, NewExtension: string): string =
    var SplitPath = splitFile(Path FileLocation)
    var NewPath = SplitPath.dir / SplitPath.name
    NewPath = addFileExt(NewPath, NewExtension)
    return $NewPath

proc SetFileExtensionJSON*(FileLocation: string): string =
    return ReplaceFileExtension(FileLocation, ExtensionJSON)

proc SetFileExtensionBIC*(FileLocation: string): string =
    return ReplaceFileExtension(FileLocation, ExtensionBIC)

proc SetFileExtensionSqlite*(FileLocation: string): string =
    return ReplaceFileExtension(FileLocation, ExtensionSqlite)

proc GetSubdirectoriesByPattern(ParentDirectory: string, SearchPattern: string): seq[string] =
    var SubPattern = ParentDirectory & SearchPattern
    echo "Searching for subdirectories " & SubPattern
    return toSeq(walkDirs(SubPattern))

proc GetSubdirectoriesAll(ParentDirectory: string): seq[string] =
    return GetSubdirectoriesByPattern(ParentDirectory, PatternSubdirectoriesAll)

proc GetSubdirectoriesBackup(ParentDirectory: string): seq[string] =
    return GetSubdirectoriesByPattern(ParentDirectory, PatternSubdirectoriesBackup)

proc TimestampString(): string =
    var NowString = $now()
    NowString = replace(NowString, "-", "")
    NowString = replace(NowString, ":", "")
    NowString = replace(NowString, "T", "_")
    delete(NowString, len(NowString)-4 .. len(NowString)-1)
    return NowString

proc DeleteBackupDirectories(DirectoryList: var seq[string]) =
    sort(DirectoryList, Descending)
    for i in DirectoryList.low ..< DirectoryList.high:
        #removeDir(DirectoryList[i])
        echo $DirectoryList[i]

proc PurgeBackupDirectories(OperationSettings: SettingsPackage) =
    var TargetDirectory = OperationSettings.OutputBIC

    if OperationSettings.ReadSubdirectories:
        var SubdirectoriesInTarget = GetSubdirectoriesAll(TargetDirectory)
        for i in SubdirectoriesInTarget.low .. SubdirectoriesInTarget.high:
            var BackupDirectories = GetSubdirectoriesBackup(SubdirectoriesInTarget[i])
            DeleteBackupDirectories(BackupDirectories)
    else:
        var BackupDirectories = GetSubdirectoriesBackup(TargetDirectory)
        DeleteBackupDirectories(BackupDirectories)


#[
var seqfiles: seq[string]
#seqfiles = GetBICFiles("""C:\Users\jorda\Documents\Neverwinter Nights\servervault""", true)
seqfiles = GetBICFiles("""C:\Users\jorda\Documents\Neverwinter Nights\servervault\QR6RKGPV""", false)
for i in seqfiles.low .. seqfiles.high:
    echo seqfiles[i]
]#