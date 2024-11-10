import std/[os, paths, sequtils]
import /[conversions_stringpath, io_constants]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]

proc GetFilesByPattern(Directory: Path, ReadSubdirectories: bool, FileTypePattern: Path): seq[Path]
proc GetBICFiles*(OperationSettings: SettingsPackage): seq[Path]
proc GetBICFiles*(Directory: Path): seq[Path]
proc GetJSONFiles*(OperationSettings: SettingsPackage): seq[Path]

proc GetSubdirectoriesByPattern(ParentDirectory: Path, SearchPattern: Path): seq[Path]
proc GetSubdirectoriesAll*(ParentDirectory: Path): seq[Path]
proc GetSubdirectoriesBackup*(ParentDirectory: Path): seq[Path]

proc GetFilesByPattern(Directory: Path, ReadSubdirectories: bool, FileTypePattern: Path): seq[Path] =
    var
        DirectoriesToSearch: seq[Path]
        SearchPattern: Path
        FilesAsString: seq[string]
        FilesAsPath: seq[Path]

    if ReadSubdirectories:
        DirectoriesToSearch = GetSubdirectoriesAll(Directory)
    else:
        DirectoriesToSearch.add(Directory)

    for i in DirectoriesToSearch.low .. DirectoriesToSearch.high:
        SearchPattern = DirectoriesToSearch[i] / FileTypePattern
        echo "Searching for " & SearchPattern.string
        FilesAsString = concat(FilesAsString, toSeq(walkFiles(SearchPattern.string)))

    FilesAsPath = SeqStringToSeqPath(FilesAsString)
    return FilesAsPath

proc GetBICFiles*(OperationSettings: SettingsPackage): seq[Path] =
    GetFilesByPattern(OperationSettings.InputBIC, OperationSettings.ReadSubdirectories, PatternExtensionBIC)

proc GetBICFiles*(Directory: Path): seq[Path] =
    GetFilesByPattern(Directory, false, PatternExtensionBIC)

proc GetJSONFiles*(OperationSettings: SettingsPackage): seq[Path] =
    GetFilesByPattern(OperationSettings.InputJSON, OperationSettings.ReadSubdirectories, PatternExtensionJSON)

proc GetSubdirectoriesByPattern(ParentDirectory: Path, SearchPattern: Path): seq[Path] =
    var
        SubdirectoryPattern = ParentDirectory / SearchPattern
        SubdirectoriesAsString: seq[string]
        SubdirectoriesAsPath: seq[Path]
    echo "Searching for subdirectories " & SubdirectoryPattern.string
    SubdirectoriesAsString = toSeq(walkDirs(SubdirectoryPattern.string))
    SubdirectoriesAsPath = SeqStringToSeqPath(SubdirectoriesAsString)
    return SubdirectoriesAsPath

proc GetSubdirectoriesAll*(ParentDirectory: Path): seq[Path] =
    return GetSubdirectoriesByPattern(ParentDirectory, PatternSubdirectoriesAll)

proc GetSubdirectoriesBackup*(ParentDirectory: Path): seq[Path] =
    return GetSubdirectoriesByPattern(ParentDirectory, PatternSubdirectoriesBackup)