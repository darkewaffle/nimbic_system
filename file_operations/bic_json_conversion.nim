import std/[algorithm, dirs, json, os, paths, streams, strutils, tables]

import /[io_operations, nwn_gff_excerpts]
import ../nimbic/settings/[object_settingspackage]

import ../neverwinterdotnim/neverwinter/[gff, gffjson]


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

    #If ExpectSqlite is enabled use the InputFile .bic location to construct a path
    #for a .sqlite file in the OutputDirectory with the same file name.
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

    #Create the path that a .sqlite file would be in if it exists. Var is created outside of if so that it can be re-used for cleanup at end of proc.
    #If ExpectSqlite is enabled and the file exists then insert the sqlite file into the GFF structure.
    var InputPathSQL = SetFileExtensionSqlite(InputFile)
    if OperationSettings.ExpectSqlite:
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

    #Option to autobackup BIC before it is overwritten
    if OperationSettings.AutoBackup:
        if fileExists(OutputPath):
            var OutputSplit = splitFile(Path OutputPath)
            #BackupDirectoryFullName is a pre-determined value in io_operations
            var BackupPath = OutputSplit.dir / Path(BackupDirectoryFullName)
            if not(dirExists(BackupPath)):
                createDir(BackupPath)
            copyFileToDir(OutputPath, $BackupPath)

    var OutputStream = openFileStream(OutputPath, fmWrite)
    OutputStream.write(InputAsGFF)

    InputStream.close
    OutputStream.close

    #Option to automatically delete JSON and Sqlite after writing BIC
    if OperationSettings.AutoCleanup:
        removeFile(InputFile)
        echo "Autocleanup deleting: " & $InputFile
        if fileExists(InputPathSQL):
            removeFile(InputPathSQL)
            echo "Autocleanup deleting: " & $InputPathSQL

    echo "Translation to BIC complete: " & OutputPath