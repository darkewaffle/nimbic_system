import std/[os, sequtils]

import /[io_constants]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]

proc GetFilesByPattern(DirectoryPath: string, ReadSubdirectories: bool, FileTypePattern: string): seq[string]
proc GetBICFiles*(OperationSettings: SettingsPackage): seq[string]
proc GetBICFiles*(DirectoryPath: string): seq[string]
proc GetJSONFiles*(OperationSettings: SettingsPackage): seq[string]

proc GetSubdirectoriesByPattern(ParentDirectory: string, SearchPattern: string): seq[string]
proc GetSubdirectoriesAll*(ParentDirectory: string): seq[string]
proc GetSubdirectoriesBackup*(ParentDirectory: string): seq[string]



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



proc GetSubdirectoriesByPattern(ParentDirectory: string, SearchPattern: string): seq[string] =
    var SubPattern = ParentDirectory & SearchPattern
    echo "Searching for subdirectories " & SubPattern
    return toSeq(walkDirs(SubPattern))

proc GetSubdirectoriesAll*(ParentDirectory: string): seq[string] =
    return GetSubdirectoriesByPattern(ParentDirectory, PatternSubdirectoriesAll)

proc GetSubdirectoriesBackup*(ParentDirectory: string): seq[string] =
    return GetSubdirectoriesByPattern(ParentDirectory, PatternSubdirectoriesBackup)