import std/[algorithm, dirs, os, paths, random, sequtils, strutils, times]
import echo_feedback
import object_settingspackage

proc GetFilesByPattern(DirectoryPath: string, ReadSubdirectories: bool, FileTypePattern: string): seq[string]
#proc GetBICFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string]
#proc GetJSONFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string]
proc GetBICFiles*(OperationSettings: SettingsPackage): seq[string]
proc GetJSONFiles*(OperationSettings: SettingsPackage): seq[string]

proc CreateOutputPath(FileLocation: string, OutputDirectory: string, FileExtension: string, Overwrite: bool = true): string
proc CreateOutputPathJSON*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true): string
proc CreateOutputPathBIC*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true): string
proc CreateOutputPathSqlite*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true): string
proc CreateOutputPathHTML*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true): string

proc ReplaceFileExtension*(FileLocation: string, NewExtension: string): string
proc SetFileExtensionJSON*(FileLocation: string): string
proc SetFileExtensionBIC*(FileLocation: string): string
proc SetFileExtensionSqlite*(FileLocation: string): string

proc GetSubdirectoriesByPattern(ParentDirectory: string, SearchPattern: string): seq[string]
proc GetSubdirectoriesAll(ParentDirectory: string): seq[string]
proc GetSubdirectoriesBackup(ParentDirectory: string): seq[string]

proc PurgeBackupDirectories*(OperationSettings: SettingsPackage)
proc DeleteDirectories(DirectoryList: var seq[string], KeepLast: int)

proc RestoreBackup*(OperationSettings: SettingsPackage)
proc ValidateBackupName(InputName: var string)
proc CopyBackupBICs(BackupDirectory: string, ParentDirectory: string)

proc TimestampString(): string

const
    ExtensionJSON* = """.json"""
    ExtensionBIC* = """.bic"""
    ExtensionSQLite* = """.sqlite3"""
    ExtensionHTML* = """.html"""

    PatternExtensionJSON = """\*""" & ExtensionJSON
    PatternExtensionBIC = """\*""" & ExtensionBIC
    PatternExtensionSQlite = """\*""" & ExtensionSQLite
    PatternExtensionHTML = """\*""" & ExtensionHTML

    BackupDirectoryPrefix = """BIC_Backup_"""
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

proc GetBICFiles*(DirectoryPath: string): seq[string] =
    GetFilesByPattern(DirectoryPath, false, PatternExtensionBIC)

proc GetJSONFiles*(OperationSettings: SettingsPackage): seq[string] =
    GetFilesByPattern(OperationSettings.InputJSON, OperationSettings.ReadSubdirectories, PatternExtensionJSON)
#[
proc GetBICFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string] =
    GetFilesByPattern(DirectoryPath, PatternExtensionBIC, ReadSubdirectories)

proc GetJSONFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string] =
    GetFilesByPattern(DirectoryPath, PatternExtensionJSON, ReadSubdirectories)
]#

proc CreateOutputPath(FileLocation: string, OutputDirectory: string, FileExtension: string, Overwrite: bool = true): string =
    var SplitPath = splitFile(Path FileLocation)
    var OutputPath = Path(OutputDirectory)
    if not(dirExists(OutputPath)):
        EchoWarning("Path does not exist, attempting to create " & $OutputPath)
        createDir(OutputPath)
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

proc CreateOutputPathHTML*(FileLocation: string, OutputDirectory: string, Overwrite: bool = true): string =
    return CreateOutputPath(FileLocation, OutputDirectory, ExtensionHTML, Overwrite)

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

proc PurgeBackupDirectories*(OperationSettings: SettingsPackage) =
    var LatestBackupsToKeep: int
    if OperationSettings.Mode == "purgebackups":
        LatestBackupsToKeep = 1
    elif OperationSettings.Mode == "purgebackupsall":
        LatestBackupsToKeep = 0
    else:
        LatestBackupsToKeep = 1

    var TargetDirectory = OperationSettings.OutputBIC

    if OperationSettings.ReadSubdirectories:
        var SubdirectoriesInTarget = GetSubdirectoriesAll(TargetDirectory)
        for i in SubdirectoriesInTarget.low .. SubdirectoriesInTarget.high:
            var BackupDirectories = GetSubdirectoriesBackup(SubdirectoriesInTarget[i])
            DeleteDirectories(BackupDirectories, LatestBackupsToKeep)
    else:
        var BackupDirectories = GetSubdirectoriesBackup(TargetDirectory)
        DeleteDirectories(BackupDirectories, LatestBackupsToKeep)

proc DeleteDirectories(DirectoryList: var seq[string], KeepLast: int) =
    sort(DirectoryList, Ascending)
    for i in DirectoryList.low .. DirectoryList.high - KeepLast:
        removeDir(DirectoryList[i])
        EchoNotice("Deleting directory: " & $DirectoryList[i])

proc RestoreBackup*(OperationSettings: SettingsPackage) =
    var TargetDirectory = OperationSettings.OutputBIC
    var BackupToRestore = OperationSettings.RestoreFrom
    ValidateBackupName(BackupToRestore)

    if OperationSettings.ReadSubdirectories:
        var SubdirectoriesInTarget = GetSubdirectoriesAll(TargetDirectory)
        for i in SubdirectoriesInTarget.low .. SubdirectoriesInTarget.high:
            var BackupFullPath = SubdirectoriesInTarget[i] & """\""" & BackupToRestore
            CopyBackupBICs(BackupFullPath, SubdirectoriesInTarget[i])
    else:
        var BackupFullPath = TargetDirectory & """\""" & BackupToRestore
        CopyBackupBICs(BackupFullPath, TargetDirectory)

proc ValidateBackupName(InputName: var string) =
    if InputName.startsWith("""20"""):
        InputName = BackupDirectoryPrefix & InputName

proc CopyBackupBICs(BackupDirectory: string, ParentDirectory: string) =
    if dirExists(BackupDirectory):
        var BackupBICs = GetBICFiles(BackupDirectory)
        for i in BackupBICs.low .. BackupBICs.high:
            copyFileToDir(BackupBICs[i], ParentDirectory)
            EchoNotice("Copying file: " & BackupBICs[i] & " > " & ParentDirectory)
    else:
        EchoError("Backup directory not found: " & BackupDirectory)