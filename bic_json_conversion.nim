import std/[strutils, algorithm, streams, json, tables, os, paths, dirs]
import std/private/osfiles
import neverwinterdotnim/neverwinter/[gff, gffjson]
import io_operations
import nwn_gff_excerpts
import object_settingspackage


#proc BICtoJSON*(InputFile: string, OutputDirectory: string, ExpectSqlite: bool = false, ConfigWriteInPlace: bool = false)
#proc JSONtoBIC*(InputFile: string, OutputDirectory: string, ExpectSqlite: bool = false, ConfigWriteInPlace: bool = false)

proc BICtoJSON*(InputFile: string, OperationSettings: SettingsPackage)
proc JSONtoBIC*(InputFile: string, OperationSettings: SettingsPackage)


proc BICtoJSON*(InputFile: string, OperationSettings: SettingsPackage) =
    echo "Attempting translation to JSON: " & InputFile
    #Streams data from InputFile as a string
    var InputStream = newStringStream(readFile(InputFile))

    #Translate raw string stream to GFF
    var InputAsGFF: GffRoot
    InputAsGFF = InputStream.readGffRoot(false)

    #Determine the directory to write to.
    #WriteInPlace writes the JSON to the same folder the BIC is in.
    var WriteToDirectory: string
    if OperationSettings.WriteInPlace:
        var InputSplit = splitFile(Path InputFile)
        WriteToDirectory = $InputSplit.dir
    else:
        WriteToDirectory = OperationSettings.OutputJSON

    if OperationSettings.ExpectSqlite:
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


proc JSONtoBIC*(InputFile: string, OperationSettings: SettingsPackage) =
    echo "Attempting translation to BIC: " & InputFile
    #Streams data from InputFile as a string
    var InputStream = newStringStream(readFile(InputFile))
    
    #Translate raw string to JSON and then to GFF
    var InputAsGFF: GffRoot
    InputAsGFF = InputStream.parseJson(InputFile).gffRootFromJson()

    if OperationSettings.ExpectSqlite:
        var InputPathSQL = SetFileExtensionSqlite(InputFile)
        if fileExists(InputPathSQL):
            PackSqliteIntoGFF(InputAsGFF, InputPathSQL)
            echo "Packing SQL into BIC " & InputPathSQL

    #Creates path for BIC to be saved to
    var OutputPath: string
    if OperationSettings.WriteInPlace:
        var InputSplit = splitFile(Path InputFile)
        OutputPath = CreateOutputPathBIC(InputFile, $InputSplit.dir)
    else:
        OutputPath = CreateOutputPathBIC(InputFile, OperationSettings.OutputBIC)

    #Option to autobackup .bic before it is overwritten
    if OperationSettings.AutoBackup:
        if fileExists(OutputPath):
            var OutputSplit = splitFile(Path OutputPath)
            #//==BackupDirectoryFullName 'global'
            var BackupPath = OutputSplit.dir / Path(BackupDirectoryFullName)
            if not(dirExists(BackupPath)):
                createDir(BackupPath)
            copyFileToDir(OutputPath, $BackupPath)

    var OutputStream = openFileStream(OutputPath, fmWrite)
    OutputStream.write(InputAsGFF)

    InputStream.close
    OutputStream.close
    echo "Translation to BIC complete: " & OutputPath

#[
proc BICtoJSON*(InputFile: string, OutputDirectory: string, ExpectSqlite: bool = false, ConfigWriteInPlace: bool = false) =
    echo "Attempting translation to JSON: " & InputFile
    #Streams data from InputFile as a string
    var InputStream = newStringStream(readFile(InputFile))

    #Translate raw string stream to GFF
    var InputAsGFF: GffRoot
    InputAsGFF = InputStream.readGffRoot(false)

    var WriteToDirectory: string
    if ConfigWriteInPlace:
        var InputSplit = splitFile(Path InputFile)
        WriteToDirectory = $InputSplit.dir
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
    var OutputPath: string
    if ConfigWriteInPlace:
        var InputSplit = splitFile(Path InputFile)
        OutputPath = CreateOutputPathBIC(InputFile, $InputSplit.dir)
    else:
        OutputPath = CreateOutputPathBIC(InputFile, OutputDirectory)

    #Option to autobackup .bic before it is overwritten
    if fileExists(OutputPath):
        var OutputSplit = splitFile(Path OutputPath)
        var BackupPath = OutputSplit.dir / Path(BackupDirectoryFullName)
        if not(dirExists(BackupPath)):
            createDir(BackupPath)
        copyFileToDir(OutputPath, $BackupPath)

    var OutputStream = openFileStream(OutputPath, fmWrite)
    OutputStream.write(InputAsGFF)

    InputStream.close
    OutputStream.close
    echo "Translation to BIC complete: " & OutputPath
]#