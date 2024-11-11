import std/[algorithm, dirs, os, paths, strutils, times]
import /[conversions_stringpath, get_files, io_constants]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]

proc PurgeBackupDirectories*(OperationSettings: SettingsPackage)
proc DeleteDirectories(DirectoryList: seq[Path], KeepLast: int)
proc RestoreBackup*(OperationSettings: SettingsPackage)
proc ValidateBackupName(InputName: Path): Path
proc ValidateBackupName(InputName: string): string
proc CopyBackupBICs(BackupDirectory: Path, ParentDirectory: Path)
proc TimestampString(): string

let
    OperationTimestamp* = TimestampString()
    BackupDirectoryFullName* = Path(BackupDirectoryPrefix & OperationTimestamp)

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

proc DeleteDirectories(DirectoryList: seq[Path], KeepLast: int) =
    var DirectoryListAsString = SeqPathToSeqString(DirectoryList)
    sort(DirectoryListAsString, Ascending)
    var DirectoryListAsSortedPaths = SeqStringToSeqPath(DirectoryListAsString)

    for i in DirectoryListAsSortedPaths.low .. DirectoryListAsSortedPaths.high - KeepLast:
        removeDir(DirectoryListAsSortedPaths[i])
        EchoNotice("Deleting directory: " & DirectoryListAsSortedPaths[i].string)

proc RestoreBackup*(OperationSettings: SettingsPackage) =
    var 
        TargetDirectory = OperationSettings.OutputBIC
        BackupToRestore = ValidateBackupName(OperationSettings.RestoreFrom)

    if OperationSettings.ReadSubdirectories:
        var SubdirectoriesInTarget = GetSubdirectoriesAll(TargetDirectory)
        for i in SubdirectoriesInTarget.low .. SubdirectoriesInTarget.high:
            var BackupFullPath = SubdirectoriesInTarget[i] / BackupToRestore
            CopyBackupBICs(BackupFullPath, SubdirectoriesInTarget[i])
    else:
        var BackupFullPath = TargetDirectory / BackupToRestore
        CopyBackupBICs(BackupFullPath, TargetDirectory)

proc ValidateBackupName(InputName: Path): Path =
    return Path(ValidateBackupName(InputName.string))

proc ValidateBackupName(InputName: string): string =
    if InputName.startsWith("""20"""):
        return BackupDirectoryPrefix & InputName
    else:
        return InputName

proc CopyBackupBICs(BackupDirectory: Path, ParentDirectory: Path) =
    if dirExists(BackupDirectory):
        var BackupBICs = GetBICFiles(BackupDirectory)
        for i in BackupBICs.low .. BackupBICs.high:
            copyFileToDir(BackupBICs[i].string, ParentDirectory.string)
            EchoNotice("Copying file: " & BackupBICs[i].string & " > " & ParentDirectory.string)
    else:
        EchoError("Backup directory not found: " & BackupDirectory.string)

proc TimestampString(): string =
    var NowString = $now()
    NowString = replace(NowString, "-", "")
    NowString = replace(NowString, ":", "")
    NowString = replace(NowString, "T", "_")
    delete(NowString, len(NowString)-4 .. len(NowString)-1)
    return NowString