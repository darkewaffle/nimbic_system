import std/[dirs, json, os, parseopt, paths]
import nim_bic_editor_help
import nimbic_config
import nimbic_arguments
import nimbic_evaluate_settings
import bic_json_conversion
import character_getters_setters
import feat_add
import feat_remove
import ability_modify
import io_operations
import echo_feedback
import utility_procs
import hp_modify
import object_settingspackage
from read2da import Initialize2DAs


#proc PerformModeOperation()
proc PerformModeOperationFromPackage()
#proc ValidateModeArguments()
proc ValidateModeArgumentsFromPackage()
#proc EvaluateCharacterRequirements(CharacterJSON: JsonNode, CharacterFileLocation: string): bool
proc EvaluateCharacterRequirementsFromPackage(CharacterJSON: JsonNode, CharacterFileLocation: string): bool
proc GetCore2DAFiles(OperationSettings: SettingsPackage)


#Operational variables
var
#  CommandLineArguments = initOptParser(quoteShellCommand(commandLineParams()))
  MeetsRequirements = false
  FilesToChange: seq[string]
  CharacterJSON: JsonNode
  RemovalSuccessful: bool
  ModificationSuccessful: bool
  OperationSettings = NewSettingsPackage()
const
  ValidModes = ["help", "bictojson", "jsontobic", "addclassfeat", "removeclassfeat", "alterclasshp", "maxhp", "addfeat", "removefeat", "modifyability"]
  ModeNoOperation = ["help"]
  ModeFileConversion = ["bictojson", "jsontobic"]
  ModeCharacterModify = ["addclassfeat", "removeclassfeat", "alterclasshp", "maxhp", "addfeat", "removefeat", "modifyability"]
  ModeRequires2DA = ["maxhp"]
  ModeRequiresClassAndLevel = ["addclassfeat", "removeclassfeat"]


#####
#Program begins here
#####
EchoSeparator()
OperationSettings = GetOperationSettings()
OperationSettings.EchoSettings()
#GetSettingsFromConfigFile()
#AssignArgumentsToVariables(CommandLineArguments)
#ReconcileCommandLineArgumentsAndConfigSettings()
#ValidateModeArguments()
ValidateModeArgumentsFromPackage()
#PerformModeOperation()
PerformModeOperationFromPackage()

proc ValidateModeArgumentsFromPackage() =
  if not(OperationSettings.Mode in ValidModes):
    echo "Invalid --mode argument specified."
    quit(QuitSuccess)

  if OperationSettings.Mode in ModeFileConversion:
    case OperationSettings.Mode:
      of "bictojson":
        if not(dirExists(Path OperationSettings.InputBIC)):
          EchoError("Directory is not valid - " & $OperationSettings.InputBic)
          quit(QuitSuccess)

      of "jsontobic":
        if not(dirExists(Path OperationSettings.InputJSON)):
          EchoError("Directory is not valid - " & $OperationSettings.InputJSON)
          quit(QuitSuccess)

  if OperationSettings.Mode in ModeCharacterModify:
    if OperationSettings.Mode in ModeRequires2DA:
      if not(dirExists(Path OperationSettings.Input2DA)):
        EchoError("Directory is not valid - " & $OperationSettings.Input2DA)
        quit(QuitSuccess)

    if not(dirExists(Path OperationSettings.InputJSON)):
      EchoError("Directory is not valid - " & $OperationSettings.InputJSON)
      quit(QuitSuccess)

    case OperationSettings.Mode:
      of "addclassfeat", "removeclassfeat":
        if not(OperationSettings.ClassActive and OperationSettings.FeatActive and OperationSettings.LevelActive):
          EchoError("A class, feat and level must be input.")
          quit(QuitSuccess)

      of "alterclasshp":
        if not(OperationSettings.ClassActive):
          EchoError("A class must be input.")
          quit(QuitSuccess)

      of "maxhp":
        #No specific requirements.
        discard

      of "addfeat":
        if not(OperationSettings.FeatActive):
          EchoError("A feat ID must be input.")
          quit(QuitSuccess)

      of "removefeat":
        if not(OperationSettings.FeatActive):
          EchoError("A feat ID must be input.")
          quit(QuitSuccess)

      of "modifyability":
        #No specific requirements.
        discard

proc PerformModeOperationFromPackage() =
  if OperationSettings.Mode in ModeNoOperation:
    case OperationSettings.Mode:
      of "help":
        EchoBlank()
        DisplayHelp()
        quit(QuitSuccess)

  if OperationSettings.Mode in ModeFileConversion:
    case OperationSettings.Mode:
      of "bictojson":
        FilesToChange = GetBICFiles(OperationSettings)
        for i in FilesToChange.low .. FilesToChange.high:
          BICtoJSON(FilesToChange[i], OperationSettings)

      of "jsontobic":
        FilesToChange = GetJSONFiles(OperationSettings)
        for i in FilesToChange.low .. FilesToChange.high:
          JSONtoBIC(FilesToChange[i], OperationSettings)

  if OperationSettings.Mode in ModeCharacterModify:
    if OperationSettings.Mode in ModeRequires2DA:
      GetCore2DAFiles(OperationSettings)

    FilesToChange = GetJSONFiles(OperationSettings)
    for i in FilesToChange.low .. FilesToChange.high:
      EchoBlank()
      CharacterJSON = parseFile(FilesToChange[i])
      MeetsRequirements = EvaluateCharacterRequirementsFromPackage(CharacterJSON, FilesToChange[i])

      if not(MeetsRequirements):
        discard
      else:
        case OperationSettings.Mode:
          of "addclassfeat":
            AddClassFeat(CharacterJSON, OperationSettings)

          of "removeclassfeat":
            RemovalSuccessful = RemoveClassFeat(CharacterJSON, OperationSettings)
            MeetsRequirements = MeetsRequirements and RemovalSuccessful

          of "alterclasshp":
            ModificationSuccessful = AlterClassHP(CharacterJSON, OperationSettings)
            MeetsRequirements = MeetsRequirements and ModificationSuccessful

          of "maxhp":
            ModificationSuccessful = MaximizeHP(CharacterJSON)
            MeetsRequirements = MeetsRequirements and ModificationSuccessful

          of "addfeat":
            AddLevelFeat(CharacterJSON, OperationSettings)

          of "removefeat":
            RemovalSuccessful = RemoveLevelFeat(CharacterJSON, OperationSettings)
            MeetsRequirements = MeetsRequirements and RemovalSuccessful

          of "modifyability":
            ModifyAbilities(CharacterJSON, OperationSettings.AbilityInput)

      if MeetsRequirements:
        writeFile(FilesToChange[i], pretty(CharacterJSON, 4))
        echo "Writing to " & FilesToChange[i]

proc EvaluateCharacterRequirementsFromPackage(CharacterJSON: JsonNode, CharacterFileLocation: string): bool =
  var
    RequirementRace = true
    RequirementSubrace = true
    RequirementClass = true
    RequirementClassLevel = true
    RequirementTotalLevel = true
    RequirementResult: bool

  if OperationSettings.RaceActive:
    RequirementRace = RequirementRace and CharacterHasRace(CharacterJSON, OperationSettings.Race)
    #echo "Has required race = " & $RequirementRace

  if OperationSettings.SubraceActive :
    RequirementSubrace = RequirementSubrace and CharacterHasSubrace(CharacterJSON, OperationSettings.Subrace)
    #echo "Has required subrace = " & $RequirementSubrace

  if OperationSettings.Mode == "addclassfeat" or OperationSettings.Mode == "removeclassfeat":
    RequirementClassLevel = RequirementClassLevel and CharacterHasClassLevel(CharacterJSON, OperationSettings.Class, OperationSettings.Level)
    #echo "Has required class level = " & $RequirementClassLevel
  else:
    if OperationSettings.LevelActive:
      RequirementTotalLevel = RequirementTotalLevel and CharacterHasTotalLevel(CharacterJSON, OperationSettings.Level)
      #echo "Has required total level = " & $RequirementTotalLevel
    if OperationSettings.ClassActive:
      RequirementClass = RequirementClass and CharacterHasClass(CharacterJSON, OperationSettings.Class)
      #echo "Has required class = " & $RequirementClass

  RequirementResult = RequirementRace and RequirementSubrace and RequirementClass and RequirementClassLevel and RequirementTotalLevel
  if RequirementResult:
    EchoMessageNameFilename("Operation requirements met, " & OperationSettings.Mode & " will begin.", CharacterJSON, CharacterFileLocation)
  else:
    EchoMessageNameFilename("Operation requirements not met, " & OperationSettings.Mode & " will be skipped.", CharacterJSON, CharacterFileLocation)
  return RequirementResult

#[
proc ValidateModeArguments() =
  if not(Mode in ValidModes):
    echo "Invalid --mode argument specified."
    quit(QuitSuccess)

  if Mode in ModeFileConversion:
    case Mode:
      of "bictojson":
        if not(dirExists(Path ConfigInputBIC)):
          EchoError("Directory is not valid - " & $ConfigInputBic)
          quit(QuitSuccess)

      of "jsontobic":
        if not(dirExists(Path ConfigInputJSON)):
          EchoError("Directory is not valid - " & $ConfigInputJSON)
          quit(QuitSuccess)

  if Mode in ModeCharacterModify:
    if Mode in ModeRequires2DA:
      if not(dirExists(Path ConfigInput2DA)):
        EchoError("Directory is not valid - " & $ConfigInput2DA)
        quit(QuitSuccess)

    if not(dirExists(Path ConfigInputJSON)):
      EchoError("Directory is not valid - " & $ConfigInputJSON)
      quit(QuitSuccess)

    case Mode:
      of "addclassfeat", "removeclassfeat":
        if (RequiredClass == DefaultClass) or (FeatID == DefaultFeatID) or (RequiredLevel == DefaultLevel):
          EchoError("A class, feat and level must be input.")
          quit(QuitSuccess)

      of "alterclasshp":
        if RequiredClass == DefaultClass:
          EchoError("A class must be input.")
          quit(QuitSuccess)

      of "maxhp":
        #No specific requirements.
        discard

      of "addfeat":
        if FeatID == DefaultFeatID:
          EchoError("A feat ID must be input.")
          quit(QuitSuccess)

      of "removefeat":
        if FeatID == DefaultFeatID:
          EchoError("A feat ID must be input.")
          quit(QuitSuccess)

      of "modifyability":
        #No specific requirements.
        discard


proc PerformModeOperation() =
  if Mode in ModeNoOperation:
    case Mode:
      of "help":
        EchoBlank()
        DisplayHelp()
        quit(QuitSuccess)

  if Mode in ModeFileConversion:
    case Mode:
      of "bictojson":
        FilesToChange = GetBICFiles(ConfigInputBIC, ConfigReadSubdirectories)
        for i in FilesToChange.low .. FilesToChange.high:
          BICtoJSON(FilesToChange[i], ConfigOutputJSON, ConfigSqlite, ConfigWriteInPlace)

      of "jsontobic":
        FilesToChange = GetJSONFiles(ConfigInputJSON, ConfigReadSubdirectories)
        for i in FilesToChange.low .. FilesToChange.high:
          JSONtoBIC(FilesToChange[i], ConfigOutputBIC, ConfigSqlite, ConfigWriteInPlace)

  if Mode in ModeCharacterModify:
    if Mode in ModeRequires2DA:
      GetCore2DAFiles()

    FilesToChange = GetJSONFiles(ConfigInputJSON, ConfigReadSubdirectories)
    for i in FilesToChange.low .. FilesToChange.high:
      EchoBlank()
      CharacterJSON = parseFile(FilesToChange[i])
      MeetsRequirements = EvaluateCharacterRequirements(CharacterJSON, FilesToChange[i])

      if not(MeetsRequirements):
        discard
      else:
        case Mode:
          of "addclassfeat":
            AddClassFeat(CharacterJSON, RequiredClass, RequiredLevel, FeatID)

          of "removeclassfeat":
            RemovalSuccessful = RemoveClassFeat(CharacterJSON, RequiredClass, RequiredLevel, FeatID)
            MeetsRequirements = MeetsRequirements and RemovalSuccessful

          of "alterclasshp":
            ModificationSuccessful = AlterClassHP(CharacterJSON, RequiredClass, HPInput)
            MeetsRequirements = MeetsRequirements and ModificationSuccessful

          of "maxhp":
            ModificationSuccessful = MaximizeHP(CharacterJSON)
            MeetsRequirements = MeetsRequirements and ModificationSuccessful

          of "addfeat":
            AddLevelFeat(CharacterJSON, IfNoLevelThen1(RequiredLevel), FeatID)

          of "removefeat":
            RemovalSuccessful = RemoveLevelFeat(CharacterJSON, IfNoLevelThen1(RequiredLevel), FeatID)
            MeetsRequirements = MeetsRequirements and RemovalSuccessful

          of "modifyability":
            ModifyAbilities(CharacterJSON, AbilityInput)

      if MeetsRequirements:
        writeFile(FilesToChange[i], pretty(CharacterJSON, 4))
        echo "Writing to " & FilesToChange[i]

proc EvaluateCharacterRequirements(CharacterJSON: JsonNode, CharacterFileLocation: string): bool =
  var
    RequirementRace = true
    RequirementSubrace = true
    RequirementClass = true
    RequirementClassLevel = true
    RequirementTotalLevel = true
    RequirementResult: bool

  if RequiredRace != DefaultRace:
    RequirementRace = RequirementRace and CharacterHasRace(CharacterJSON, RequiredRace)
    #echo "Has required race = " & $RequirementRace

  if RequiredSubrace != DefaultSubrace:
    RequirementSubrace = RequirementSubrace and CharacterHasSubrace(CharacterJSON, RequiredSubrace)
    #echo "Has required subrace = " & $RequirementSubrace

  if Mode == "addclassfeat" or Mode == "removeclassfeat":
    RequirementClassLevel = RequirementClassLevel and CharacterHasClassLevel(CharacterJSON, RequiredClass, RequiredLevel)
    #echo "Has required class level = " & $RequirementClassLevel
  else:
    if RequiredLevel != DefaultLevel:
      RequirementTotalLevel = RequirementTotalLevel and CharacterHasTotalLevel(CharacterJSON, RequiredLevel)
      #echo "Has required total level = " & $RequirementTotalLevel
    if RequiredClass != DefaultClass:
      RequirementClass = RequirementClass and CharacterHasClass(CharacterJSON, RequiredClass)
      #echo "Has required class = " & $RequirementClass

  RequirementResult = RequirementRace and RequirementSubrace and RequirementClass and RequirementClassLevel and RequirementTotalLevel
  if RequirementResult:
    EchoMessageNameFilename("Operation requirements met, " & Mode & " will begin.", CharacterJSON, CharacterFileLocation)
  else:
    EchoMessageNameFilename("Operation requirements not met, " & Mode & " will be skipped.", CharacterJSON, CharacterFileLocation)
  return RequirementResult
]#
proc GetCore2DAFiles(OperationSettings: SettingsPackage) =
  Initialize2DAs(OperationSettings)
  FillRDDHPLookup()