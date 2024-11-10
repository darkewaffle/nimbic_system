import std/[dirs, files, json, os, paths, streams]

import /[nwn_gff_excerpts]
import ../[interface_io]
import ../../nimbic/settings/[object_settingspackage]
import ../../neverwinterdotnim/neverwinter/[gff, gffjson]

proc JSONtoBIC*(InputFile: Path, OperationSettings: SettingsPackage)

proc JSONtoBIC*(InputFile: Path, OperationSettings: SettingsPackage) =
    echo "Attempting translation to BIC: " & InputFile.string
    #Streams data from InputFile as a string
    var InputStream = newStringStream(readFile(InputFile.string))
    
    #Translate raw string to JSON and then to GFF
    var InputAsGFF: GffRoot
    InputAsGFF = InputStream.parseJson(InputFile.string).gffRootFromJson()

    #Create the path that a .sqlite file would be in if it exists. Var is created outside of if so that it can be re-used for cleanup at end of proc.
    #If ExpectSqlite is enabled and the file exists then insert the sqlite file into the GFF structure.
    var InputPathSQL = SetFileExtensionSqlite(InputFile)
    if OperationSettings.ExpectSqlite:
        if fileExists(InputPathSQL):
            PackSqliteIntoGFF(InputAsGFF, InputPathSQL)
            echo "Packing SQL into BIC " & InputPathSQL.string

    #Creates path for BIC to be saved to
    var OutputPath: Path
    if OperationSettings.WriteInPlace:
        var InputSplit = splitFile(InputFile)
        OutputPath = CreateOutputPathBIC(InputFile, InputSplit.dir)
    else:
        OutputPath = CreateOutputPathBIC(InputFile, OperationSettings.OutputBIC)

    #Option to autobackup BIC before it is overwritten
    if OperationSettings.AutoBackup:
        if fileExists(OutputPath):
            var OutputSplit = splitFile(OutputPath)
            #BackupDirectoryFullName is a pre-determined value in file_operations/io_operations/backups.nim
            var BackupPath = OutputSplit.dir / Path(BackupDirectoryFullName)
            if not(dirExists(BackupPath)):
                createDir(BackupPath)
            copyFileToDir(OutputPath.string, BackupPath.string)

    var OutputStream = openFileStream(OutputPath.string, fmWrite)
    OutputStream.write(InputAsGFF)

    InputStream.close
    OutputStream.close

    #Option to automatically delete JSON and Sqlite after writing BIC
    if OperationSettings.AutoCleanup:
        removeFile(InputFile)
        echo "Autocleanup deleting: " & InputFile.string
        if fileExists(InputPathSQL):
            removeFile(InputPathSQL)
            echo "Autocleanup deleting: " & InputPathSQL.string

    echo "Translation to BIC complete: " & OutputPath.string