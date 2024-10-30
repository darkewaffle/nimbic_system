import std/[dirs, os, paths, sequtils, strutils, times]
import echo_feedback

proc GetFilesByPattern(DirectoryPath: string, FileTypePattern: string, ReadSubdirectories: bool = false): seq[string]
proc GetBICFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string]
proc GetJSONFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string]

proc CreateOutputPath(FileLocation: string, OutputDirectory: string, FileExtension: string): string
proc CreateOutputPathJSON*(FileLocation: string, OutputDirectory: string): string
proc CreateOutputPathBIC*(FileLocation: string, OutputDirectory: string): string
proc CreateOutputPathSqlite*(FileLocation: string, OutputDirectory: string): string

proc ReplaceFileExtension*(FileLocation: string, NewExtension: string): string
proc SetFileExtensionJSON*(FileLocation: string): string
proc SetFileExtensionBIC*(FileLocation: string): string
proc SetFileExtensionSqlite*(FileLocation: string): string

proc GetSubDirectories*(ParentDirectory: string): seq[string]

proc TimestampString(): string

const
  ExtensionJSON* = """.json"""
  ExtensionBIC* = """.bic"""
  ExtensionSQLite* = """.sqlite3"""
  FilterExtensionJSON = """\*""" & ExtensionJSON
  FilterExtensionBIC = """\*""" & ExtensionBIC
  FilterExtensionSQlite = """\*""" & ExtensionSQLite
  FilterSubDirectories = """\*"""


proc GetFilesByPattern(DirectoryPath: string, FileTypePattern: string, ReadSubdirectories: bool = false): seq[string] =
  var DirectoriesToSearch: seq[string]
  var SearchPattern: string
  var FileResults: seq[string]

  if ReadSubdirectories:
    DirectoriesToSearch = GetSubDirectories(DirectoryPath)
  else:
    DirectoriesToSearch.add(DirectoryPath)

  for i in DirectoriesToSearch.low .. DirectoriesToSearch.high:
    SearchPattern = DirectoriesToSearch[i] & FileTypePattern
    echo "Searching for " & SearchPattern
    FileResults = concat(FileResults, toSeq(walkPattern(SearchPattern)))

  return FileResults

proc GetBICFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string] =
  GetFilesByPattern(DirectoryPath, FilterExtensionBIC, ReadSubdirectories)

proc GetJSONFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq[string] =
  GetFilesByPattern(DirectoryPath, FilterExtensionJSON, ReadSubdirectories)


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

proc GetSubDirectories*(ParentDirectory: string): seq[string] =
  var SubPattern = ParentDirectory & FilterSubDirectories
  echo "Searching for subdirectories " & SubPattern
  return toSeq(walkDirs(SubPattern))

proc TimestampString(): string =
  var NowString = $now()
  NowString = replace(NowString, "-", "")
  NowString = replace(NowString, ":", "")
  NowString = replace(NowString, "T", "_")
  delete(NowString, len(NowString)-4 .. len(NowString)-1)
  return NowString

#[
var seqfiles: seq[string]
#seqfiles = GetBICFiles("""C:\Users\jorda\Documents\Neverwinter Nights\servervault""", true)
seqfiles = GetBICFiles("""C:\Users\jorda\Documents\Neverwinter Nights\servervault\QR6RKGPV""", false)
for i in seqfiles.low .. seqfiles.high:
  echo seqfiles[i]
]#