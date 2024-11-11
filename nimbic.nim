import std/[json, paths]
import nimbic/[echo_feedback, nimbic_help]
import nimbic/modes/[mode_groups, mode_requirements]
import nimbic/settings/[nimbic_evaluate_settings,object_settingspackage]
import file_operations/[interface_2da, interface_conversion, interface_io]
import bic_as_json_operations/[interface_operations]

proc PerformModeOperation(OperationSettings: SettingsPackage)
proc GetCore2DAFiles(OperationSettings: SettingsPackage)
proc PerformFileOperation(OperationSettings: SettingsPackage)
proc PerformJSONModification(OperationSettings: SettingsPackage)

## ## ## ## ## ## ## ## ##
##   Code begins here   ##
## ## ## ## ## ## ## ## ##
EchoSeparator()
var OperationSettings = GetOperationSettings()
if not(ValidateSettings(OperationSettings)):
    #OperationSettings.EchoSettings()
    EchoError("One more more settings required for the operation have not been met. Please verify your settings and try again.")
    quit(QuitSuccess)
PerformModeOperation(OperationSettings)


proc PerformModeOperation(OperationSettings: SettingsPackage) =
    if OperationSettings.Mode == "help":
        EchoBlank()
        DisplayHelp()
        quit(QuitSuccess)

    if OperationSettings.Mode in ModeRequires2DA:
        #Pre-load 2DA files to ensure they are ready to provide lookup results for the rest of the operation
        GetCore2DAFiles(OperationSettings)

    if OperationSettings.Mode in ModeFileOperations:
        PerformFileOperation(OperationSettings)

    if OperationSettings.Mode in ModeJSONModifications:
        PerformJSONModification(OperationSettings)

proc GetCore2DAFiles(OperationSettings: SettingsPackage) =
    Initialize2DAs(OperationSettings)
    InitializeRDDHPLookup()

proc PerformFileOperation(OperationSettings: SettingsPackage) =
    var FilesToChange: seq[Path]

    case OperationSettings.Mode:
        of "bictojson":
            FilesToChange = GetBICFiles(OperationSettings)
            for i in FilesToChange.low .. FilesToChange.high:
                BICtoJSON(FilesToChange[i], OperationSettings)

        of "jsontobic":
            FilesToChange = GetJSONFiles(OperationSettings)
            for i in FilesToChange.low .. FilesToChange.high:
                JSONtoBIC(FilesToChange[i], OperationSettings)

        of "jsontohtml":
            FilesToChange = GetJSONFiles(OperationSettings)
            for i in FilesToChange.low .. FilesToChange.high:
                JSONtoHTML(FilesToChange[i], OperationSettings)

        of "purgebackups", "purgebackupsall":
            PurgeBackupDirectories(OperationSettings)

        of "restorebackup":
            RestoreBackup(OperationSettings)

proc PerformJSONModification(OperationSettings: SettingsPackage) =
    var FilesToChange = GetJSONFiles(OperationSettings)

    for i in FilesToChange.low .. FilesToChange.high:
        var 
            CharacterJSON = parseFile(FilesToChange[i].string)
            CharacterMeetsRequirements = ValidateCharacterRequirements(OperationSettings, CharacterJSON)
            WriteChangesToJSON: bool
            FileChangeSuccessful: bool

        if not(CharacterMeetsRequirements):
            echo "Character ineligible: " & FilesToChange[i].string
            continue
        else:
            case OperationSettings.Mode:
                of "addclassfeat":
                    AddClassFeat(CharacterJSON, OperationSettings)
                    #Requirements ensure character has appropriate class/level
                    #Therefore operation has no fail condition and the changes should always be written
                    WriteChangesToJSON = true

                of "removeclassfeat":
                    FileChangeSuccessful = RemoveClassFeat(CharacterJSON, OperationSettings)
                    WriteChangesToJSON = FileChangeSuccessful

                of "alterclasshp":
                    FileChangeSuccessful = AlterClassHP(CharacterJSON, OperationSettings)
                    WriteChangesToJSON = FileChangeSuccessful

                of "maxhp":
                    FileChangeSuccessful = MaximizeHP(CharacterJSON)
                    WriteChangesToJSON = FileChangeSuccessful

                of "addfeat":
                    AddLevelFeat(CharacterJSON, OperationSettings)
                    #Requirements ensure character has appropriate class/level (or everyone is at least level 1 if no level is input)
                    #Therefore operation has no fail condition and the changes should always be written
                    WriteChangesToJSON = true

                of "removefeat":
                    FileChangeSuccessful = RemoveLevelFeat(CharacterJSON, OperationSettings)
                    WriteChangesToJSON = FileChangeSuccessful

                of "modifyability":
                    ModifyAbilities(CharacterJSON, OperationSettings)
                    #There is no fail state for this operation.
                    WriteChangesToJSON = true

        if WriteChangesToJSON:
            writeFile(FilesToChange[i].string, pretty(CharacterJSON, 4))
            EchoSuccess("Operation complete. Writing update to " & FilesToChange[i].string)
        else:
            EchoNotice("Character eligible but no changes made. " & FilesToChange[i].string)