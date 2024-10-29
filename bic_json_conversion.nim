import std/[strutils, algorithm, streams, json, tables]
import neverwinterdotnim/neverwinter/[gff, gffjson]
import io_operations
import nwn_gff_excerpts


proc BICtoJSON*(InputFile: string, OutputDirectory: string, ExpectSqlite: bool)
proc JSONtoBIC*(InputFile: string, OutputDirectory: string, ExpectSqlite: bool)


proc BICtoJSON*(InputFile: string, OutputDirectory: string, ExpectSqlite: bool) =
  echo "Attempting translation to JSON: " & InputFile
  #Streams data from InputFile as a string
  var InputStream = newStringStream(readFile(InputFile))

  #Translate raw string stream to GFF
  var InputAsGFF: GffRoot
  InputAsGFF = InputStream.readGffRoot(false)

  if ExpectSqlite:
    var OutputPathSQL = CreateOutputPathSqlite(InputFile, OutputDirectory)
    ExtractSqliteFromGFF(InputAsGFF, OutputPathSQL)

  #Translate GFF to JSON
  var OutputJSON = InputAsGFF.toJson
  #Sorts JSON before write/use
  postProcessJson(OutputJSON)

  #Creates path for JSON to be saved to
  var OutputPath = CreateOutputPathJSON(InputFile, OutputDirectory)
  var OutputStream = openFileStream(OutputPath, fmWrite)
  OutputStream.write(OutputJSON.pretty)
  OutputStream.write("\n")

  InputStream.close
  OutputStream.close
  echo "Translation to JSON complete: " & OutputPath


proc JSONtoBIC*(InputFile: string, OutputDirectory: string, ExpectSqlite: bool) =
  echo "Attempting translation to BIC: " & InputFile
  #Streams data from InputFile as a string
  var InputStream = newStringStream(readFile(InputFile))
  
  #Translate raw string to JSON and then to GFF
  var InputAsGFF: GffRoot
  InputAsGFF = InputStream.parseJson(InputFile).gffRootFromJson()

  if ExpectSqlite:
    var OutputPathSQL = CreateOutputPathSqlite(InputFile, OutputDirectory)
    PackSqliteIntoGFF(InputAsGFF, """C:\Users\jorda\Documents\NWN_Docs\nimbic_json\test.sqlite3""")

  #Creates path for BIC to be saved to
  var OutputPath = CreateOutputPathBIC(InputFile, OutputDirectory)

  var OutputStream = openFileStream(OutputPath, fmWrite)
  OutputStream.write(InputAsGFF)

  InputStream.close
  OutputStream.close
  echo "Translation to BIC complete: " & OutputPath