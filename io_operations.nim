import std/[dirs, os, paths, sequtils, strutils, times]
import echo_feedback

proc GetFilesByPattern(DirectoryPath: string, FileTypePattern: string): seq
proc GetBICFiles*(DirectoryPath: string): seq
proc GetJSONFiles*(DirectoryPath: string): seq

proc CreateOutputPath(FileLocation: string, OutputDirectory: string, FileExtension: string): string
proc CreateOutputPathJSON*(FileLocation: string, OutputDirectory: string): string
proc CreateOutputPathBIC*(FileLocation: string, OutputDirectory: string): string
proc CreateOutputPathSqlite*(FileLocation: string, OutputDirectory: string): string

proc TimestampString(): string

const
  ExtensionJSON* = """.json"""
  ExtensionBIC* = """.bic"""
  ExtensionSQLite*: string = """.sqlite3"""
  FilterExtensionJSON = """\*""" & ExtensionJSON
  FilterExtensionBIC = """\*""" & ExtensionBIC
  FilterExtensionSQlite = """\*""" & ExtensionSQLite


proc GetFilesByPattern(DirectoryPath: string, FileTypePattern: string): seq =
  var SearchPattern = DirectoryPath & FileTypePattern
  echo "Searching for " & SearchPattern
  var PatternMatches = toSeq(walkPattern(SearchPattern))
  return PatternMatches

proc GetBICFiles*(DirectoryPath: string): seq =
  GetFilesByPattern(DirectoryPath, FilterExtensionBIC)

proc GetJSONFiles*(DirectoryPath: string): seq =
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

proc TimestampString(): string =
  var NowString = $now()
  NowString = replace(NowString, "-", "")
  NowString = replace(NowString, ":", "")
  NowString = replace(NowString, "T", "_")
  delete(NowString, len(NowString)-4 .. len(NowString)-1)
  return NowString