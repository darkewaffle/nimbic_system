import std/[strutils, algorithm, streams, json, tables]
import neverwinternim/[gff, gffjson, nwn_gff_excerpts]
import io_operations


proc BICtoJSON*(InputFile: string, OutputDirectory: string)
proc JSONtoBIC*(InputFile: string, OutputDirectory: string)
proc postProcessJson(j: JsonNode)


proc BICtoJSON*(InputFile: string, OutputDirectory: string) =
  echo "Attempting translation to JSON: " & InputFile
  #Streams data from InputFile as a string
  var InputStream = newStringStream(readFile(InputFile))

  #Translate raw string stream to GFF
  var InputAsGFF: GffRoot
  InputAsGFF = InputStream.readGffRoot(false)

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


proc JSONtoBIC*(InputFile: string, OutputDirectory: string) =
  echo "Attempting translation to BIC: " & InputFile
  #Streams data from InputFile as a string
  var InputStream = newStringStream(readFile(InputFile))
  
  #Translate raw string to JSON and then to GFF
  var InputAsGFF: GffRoot
  InputAsGFF = InputStream.parseJson(InputFile).gffRootFromJson()
    
  #Creates path for BIC to be saved to
  var OutputPath = CreateOutputPathBIC(InputFile, OutputDirectory)

  var OutputStream = openFileStream(OutputPath, fmWrite)
  OutputStream.write(InputAsGFF)

  InputStream.close
  OutputStream.close
  echo "Translation to BIC complete: " & OutputPath