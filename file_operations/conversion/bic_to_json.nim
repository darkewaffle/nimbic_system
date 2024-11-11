import std/[json, paths, streams]
import /[nwn_gff_excerpts]
import ../[interface_io]
import ../../nimbic/settings/[object_settingspackage]
import ../../neverwinterdotnim/neverwinter/[gff, gffjson]

proc BICtoJSON*(InputFile: Path, OperationSettings: SettingsPackage)

proc BICtoJSON*(InputFile: Path, OperationSettings: SettingsPackage) =
    echo "Attempting translation to JSON: " & InputFile.string
    #Streams data from InputFile as a string
    var InputStream = newStringStream(readFile(InputFile.string))

    #Translate raw string stream to GFF
    var InputAsGFF: GffRoot
    InputAsGFF = InputStream.readGffRoot(false)

    #Determine the directory to write to.
    #WriteInPlace writes the JSON to the same folder the BIC is in.
    var WriteToDirectory: Path
    if OperationSettings.WriteInPlace:
        var InputSplit = splitFile(InputFile)
        WriteToDirectory = InputSplit.dir
    else:
        WriteToDirectory = OperationSettings.OutputJSON

    #If ExpectSqlite is enabled use the InputFile .bic location to construct a path
    #for a .sqlite file in the OutputDirdectory with the same file name.
    if OperationSettings.ExpectSqlite:
        var OutputPathSQL = CreateOutputPathSqlite(InputFile, WriteToDirectory)
        ExtractSqliteFromGFF(InputAsGFF, OutputPathSQL)

    #Translate GFF to JSON
    var OutputJSON = InputAsGFF.toJson
    #Sorts JSON before write/use
    postProcessJson(OutputJSON)

    #Creates path for JSON to be saved to
    var OutputPath = CreateOutputPathJSON(InputFile, WriteToDirectory)
    var OutputStream = openFileStream(OutputPath.string, fmWrite)
    OutputStream.write(OutputJSON.pretty)
    OutputStream.write("\n")

    InputStream.close
    OutputStream.close
    echo "Translation to JSON complete: " & OutputPath.string