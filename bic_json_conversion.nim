import std/[strutils, algorithm, streams, json, tables, os, paths]
import neverwinterdotnim/neverwinter/[gff, gffjson]
import io_operations
import nwn_gff_excerpts


proc BICtoJSON*(InputFile: string, OutputDirectory: string, ExpectSqlite: bool = false, ConfigWriteInPlace: bool = false)
proc JSONtoBIC*(InputFile: string, OutputDirectory: string, ExpectSqlite: bool = false, ConfigWriteInPlace: bool = false)


proc BICtoJSON*(InputFile: string, OutputDirectory: string, ExpectSqlite: bool = false, ConfigWriteInPlace: bool = false) =
  echo "Attempting translation to JSON: " & InputFile
  #Streams data from InputFile as a string
  var InputStream = newStringStream(readFile(InputFile))

  #Translate raw string stream to GFF
  var InputAsGFF: GffRoot
  InputAsGFF = InputStream.readGffRoot(false)

  var WriteToDirectory: string
  if ConfigWriteInPlace:
    var SplitPath = splitFile(Path InputFile)
    WriteToDirectory = $SplitPath.dir
  else:
    WriteToDirectory = OutputDirectory

  if ExpectSqlite:
    var OutputPathSQL = CreateOutputPathSqlite(InputFile, WriteToDirectory)
    ExtractSqliteFromGFF(InputAsGFF, OutputPathSQL)

  #Translate GFF to JSON
  var OutputJSON = InputAsGFF.toJson
  #Sorts JSON before write/use
  postProcessJson(OutputJSON)

  #Creates path for JSON to be saved to
  var OutputPath = CreateOutputPathJSON(InputFile, WriteToDirectory)
  var OutputStream = openFileStream(OutputPath, fmWrite)
  OutputStream.write(OutputJSON.pretty)
  OutputStream.write("\n")

  InputStream.close
  OutputStream.close
  echo "Translation to JSON complete: " & OutputPath


proc JSONtoBIC*(InputFile: string, OutputDirectory: string, ExpectSqlite: bool = false, ConfigWriteInPlace: bool = false) =
  echo "Attempting translation to BIC: " & InputFile
  #Streams data from InputFile as a string
  var InputStream = newStringStream(readFile(InputFile))
  
  #Translate raw string to JSON and then to GFF
  var InputAsGFF: GffRoot
  InputAsGFF = InputStream.parseJson(InputFile).gffRootFromJson()

  if ExpectSqlite:
    var InputPathSQL = SetFileExtensionSqlite(InputFile)
    if fileExists(InputPathSQL):
      PackSqliteIntoGFF(InputAsGFF, InputPathSQL)
      echo "Packing SQL into BIC " & InputPathSQL

  #Creates path for BIC to be saved to
  var OutputPath = CreateOutputPathBIC(InputFile, OutputDirectory)

  var OutputStream = openFileStream(OutputPath, fmWrite)
  OutputStream.write(InputAsGFF)

  InputStream.close
  OutputStream.close
  echo "Translation to BIC complete: " & OutputPath