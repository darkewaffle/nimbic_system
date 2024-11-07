import std/[algorithm, os, strutils, times]

import /[get_files, io_constants]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]



proc PurgeBackupDirectories*(OperationSettings: SettingsPackage)
proc DeleteDirectories(DirectoryList: var seq[string], KeepLast: int)
proc RestoreBackup*(OperationSettings: SettingsPackage)
proc ValidateBackupName(InputName: var string)
proc CopyBackupBICs(BackupDirectory: string, ParentDirectory: string)
proc TimestampString(): string



let
    OperationTimestamp* = TimestampString()
    BackupDirectoryFullName* = BackupDirectoryPrefix & OperationTimestamp



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

proc TimestampString(): string =
    var NowString = $now()
    NowString = replace(NowString, "-", "")
    NowString = replace(NowString, ":", "")
    NowString = replace(NowString, "T", "_")
    delete(NowString, len(NowString)-4 .. len(NowString)-1)
    return NowString