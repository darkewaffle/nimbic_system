import std/[dirs, json, paths]
import /[mode_groups]
import ../[echo_feedback]
import ../settings/[object_settingspackage]
import ../../bic_as_json_operations/[interface_get]

proc ValidateSettings*(InputSettings: SettingsPackage): bool
proc ValidateCharacterRequirements*(OperationSettings: SettingsPackage, CharacterJSON: JsonNode): bool

proc ValidateSettings*(InputSettings: SettingsPackage): bool =
    var CanProceed = true

    if not(InputSettings.Mode in ValidModes):
        EchoError("Invalid --mode argument specified.")
        CanProceed = false

    if InputSettings.Mode in ModeFileOperations:
        case InputSettings.Mode:
            of "bictojson":
                if not(dirExists(InputSettings.InputBIC)):
                    EchoError(".bic input directory is not valid - " & InputSettings.InputBIC.string)
                    CanProceed = false

            of "jsontobic", "jsontohtml":
                if not(dirExists(InputSettings.InputJSON)):
                    EchoError(".json input directory is not valid - " & InputSettings.InputJSON.string)
                    CanProceed = false

            of "purgebackups", "purgebackupsall":
                if not(dirExists(InputSettings.OutputBIC)):
                    EchoError(".bic output directory containing backups is not valid - " & InputSettings.OutputBIC.string)
                    CanProceed = false

            of "restorebackup":
                if not(dirExists(InputSettings.OutputBIC)):
                    EchoError(".bic output directory containing backups is not valid - " & InputSettings.OutputBIC.string)
                    CanProceed = false
                elif InputSettings.RestoreFrom == Path(""):
                    EchoError("You must specify a backup directory when using the --restorefrom:name option.")
                    CanProceed = false

    if InputSettings.Mode in ModeJSONModifications:
        if InputSettings.Mode in ModeRequires2DA:
            if not(dirExists(InputSettings.Input2DA)):
                EchoError(".2da directory is not valid - " & InputSettings.Input2DA.string)
                CanProceed = false

        if not(dirExists(InputSettings.InputJSON)):
            EchoError(".json input directory is not valid - " & InputSettings.InputJSON.string)
            CanProceed = false

        case InputSettings.Mode:
            of "addclassfeat", "removeclassfeat":
                if not(InputSettings.ClassActive and InputSettings.FeatActive and InputSettings.LevelActive):
                    EchoError("A class, feat and level must be input.")
                    CanProceed = false

            of "alterclasshp":
                if not(InputSettings.ClassActive):
                    EchoError("A class must be input.")
                    CanProceed = false

            of "maxhp":
                #No specific requirements.
                discard

            of "addfeat":
                if not(InputSettings.FeatActive):
                    EchoError("A feat ID must be input.")
                    CanProceed = false

            of "removefeat":
                if not(InputSettings.FeatActive):
                    EchoError("A feat ID must be input.")
                    CanProceed = false

            of "modifyability":
                #No specific requirements.
                discard
    return CanProceed

proc ValidateCharacterRequirements*(OperationSettings: SettingsPackage, CharacterJSON: JsonNode): bool =
    var
        RequirementRace = true
        RequirementSubrace = true
        RequirementClass = true
        RequirementClassLevel = true
        RequirementTotalLevel = true
        RequirementResult: bool

    if OperationSettings.RaceActive:
        RequirementRace = RequirementRace and CharacterHasRace(CharacterJSON, OperationSettings.Race)

    if OperationSettings.SubraceActive :
        RequirementSubrace = RequirementSubrace and CharacterHasSubrace(CharacterJSON, OperationSettings.Subrace)

    if OperationSettings.Mode == "addclassfeat" or OperationSettings.Mode == "removeclassfeat":
        RequirementClassLevel = RequirementClassLevel and CharacterHasClassLevel(CharacterJSON, OperationSettings.Class, OperationSettings.Level)
    else:
        if OperationSettings.LevelActive:
            RequirementTotalLevel = RequirementTotalLevel and CharacterHasTotalLevel(CharacterJSON, OperationSettings.Level)

        if OperationSettings.ClassActive:
            RequirementClass = RequirementClass and CharacterHasClass(CharacterJSON, OperationSettings.Class)

    RequirementResult = RequirementRace and RequirementSubrace and RequirementClass and RequirementClassLevel and RequirementTotalLevel
    return RequirementResult