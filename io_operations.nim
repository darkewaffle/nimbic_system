import std/[dirs, os, paths, sequtils, strutils, times]
import echo_feedback

proc GetFilesByPattern(DirectoryPath: string, FileTypePattern: string, ReadSubdirectories: bool = false): seq
proc GetBICFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq
proc GetJSONFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq

proc CreateOutputPath(FileLocation: string, OutputDirectory: string, FileExtension: string): string
proc CreateOutputPathJSON*(FileLocation: string, OutputDirectory: string): string
proc CreateOutputPathBIC*(FileLocation: string, OutputDirectory: string): string
proc CreateOutputPathSqlite*(FileLocation: string, OutputDirectory: string): string

proc ReplaceFileExtension*(FileLocation: string, NewExtension: string): string
proc SetFileExtensionJSON*(FileLocation: string): string
proc SetFileExtensionBIC*(FileLocation: string): string
proc SetFileExtensionSqlite*(FileLocation: string): string

proc GetSubDirectories*(ParentDirectory: string): seq

proc TimestampString(): string

const
  ExtensionJSON* = """.json"""
  ExtensionBIC* = """.bic"""
  ExtensionSQLite* = """.sqlite3"""
  FilterExtensionJSON = """\*""" & ExtensionJSON
  FilterExtensionBIC = """\*""" & ExtensionBIC
  FilterExtensionSQlite = """\*""" & ExtensionSQLite
  FilterSubDirectories = """\*"""


proc GetFilesByPattern(DirectoryPath: string, FileTypePattern: string, ReadSubdirectories: bool = false): seq =
  var SearchPattern = DirectoryPath & FileTypePattern
  echo "Searching for " & SearchPattern
  var PatternMatches = toSeq(walkPattern(SearchPattern))
  return PatternMatches

proc GetBICFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq =
  GetFilesByPattern(DirectoryPath, FilterExtensionBIC)

proc GetJSONFiles*(DirectoryPath: string, ReadSubdirectories: bool = false): seq =
  GetFilesByPattern(DirectoryPath, FilterExtensionJSON)


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

proc GetSubDirectories*(ParentDirectory: string): seq =
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