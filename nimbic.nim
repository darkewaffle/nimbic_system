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
    var 
        FilesToChange = GetJSONFiles(OperationSettings)
        CharacterJSON: JsonNode
        CharacterMeetsRequirements: bool
        FileChangeSuccessful: bool
        WriteToJSON: bool

    for i in FilesToChange.low .. FilesToChange.high:
        CharacterJSON = parseFile(FilesToChange[i].string)
        CharacterMeetsRequirements = ValidateCharacterRequirements(OperationSettings, CharacterJSON)

        if not(CharacterMeetsRequirements):
            discard
        else:
            case OperationSettings.Mode:
                of "addclassfeat":
                    AddClassFeat(CharacterJSON, OperationSettings)

                of "removeclassfeat":
                    FileChangeSuccessful = RemoveClassFeat(CharacterJSON, OperationSettings)
                    WriteToJSON = CharacterMeetsRequirements and FileChangeSuccessful

                of "alterclasshp":
                    FileChangeSuccessful = AlterClassHP(CharacterJSON, OperationSettings)
                    WriteToJSON = CharacterMeetsRequirements and FileChangeSuccessful

                of "maxhp":
                    FileChangeSuccessful = MaximizeHP(CharacterJSON)
                    WriteToJSON = CharacterMeetsRequirements and FileChangeSuccessful

                of "addfeat":
                    AddLevelFeat(CharacterJSON, OperationSettings)

                of "removefeat":
                    FileChangeSuccessful = RemoveLevelFeat(CharacterJSON, OperationSettings)
                    WriteToJSON = CharacterMeetsRequirements and FileChangeSuccessful

                of "modifyability":
                    ModifyAbilities(CharacterJSON, OperationSettings)

        if WriteToJSON:
            writeFile(FilesToChange[i].string, pretty(CharacterJSON, 4))
            EchoNotice("Operation successful. Writing to " & FilesToChange[i].string)