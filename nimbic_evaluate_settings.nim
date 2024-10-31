import nimbic_arguments
import nimbic_config
import object_settingspackage

proc ReconcileCommandLineArgumentsAndConfigSettings*()
proc EvaluateInputDirectory()
proc EvaluateOutputDirectory()
proc Evaluate2DADirectory()
proc EvaluateProduction()



var ConfigProductionState*: bool
var ConfigReadSubdirectories*: bool
var ConfigWriteInPlace*: bool

proc ReconcileCommandLineArgumentsAndConfigSettings*() =
  EvaluateInputDirectory()
  EvaluateOutputDirectory()
  Evaluate2DADirectory()
  EvaluateProduction()

proc EvaluateInputDirectory() =
  if ArgInputDirectory != DefaultInputDirectory:
    ConfigInputBIC = ArgInputDirectory
    ConfigInputJSON = ArgInputDirectory

proc EvaluateOutputDirectory() =
  if ArgOutputDirectory != DefaultOutputDirectory:
    ConfigOutputBIC = ArgOutputDirectory
    ConfigOutputJSON = ArgOutputDirectory

proc Evaluate2DADirectory() =
  if ArgInput2DA != DefaultInput2DA:
    ConfigInput2DA = ArgInput2DA

proc EvaluateProduction() =
  ConfigProductionState = ArgInputProduction and ConfigProduction
  if ConfigProductionState:
    ConfigInputBIC = ConfigServerVault
    ConfigInputJSON = ConfigServerVault
    ConfigOutputBIC = ConfigServerVault
    ConfigOutputJSON = ConfigServerVault
    ConfigReadSubdirectories = true
    ConfigWriteInPlace = true

proc GetOperationSettings(): SettingsPackage =
    var CommandLineSettings = GetSettingsFromCommandLine()
    var ConfigFileSettings = GetSettingsPackageFromConfigFile()
    var ResultSettings: SettingsPackage

    #Set values that can only come from command line.
    ResultSettings.OperationMode = CommandLineSettings.OperationMode
    ResultSettings.Race = CommandLineSettings.Race
    ResultSettings.RaceActive = CommandLineSettings.RaceActive
    ResultSettings.Subrace = CommandLineSettings.Subrace
    ResultSettings.SubraceActive = CommandLineSettings.SubraceActive
    ResultSettings.Class = CommandLineSettings.Class
    ResultSettings.ClassActive = CommandLineSettings.ClassActive
    ResultSettings.Level = CommandLineSettings.Level
    ResultSettings.LevelActive = CommandLineSettings.LevelActive
    ResultSettings.Feat = CommandLineSettings.Feat
    ResultSettings.FeatActive = CommandLineSettings.FeatActive
    ResultSettings.AbilityInput = CommandLineSettings.AbilityInput
    ResultSettings.HPInput = CommandLineSettings.HPInput

    #Set values that can only come from config.ini
    ResultSettings.ExpectSqlite = ConfigFileSettings.ExpectSqlite
    ResultSettings.AutoCleanup = ConfigFileSettings.AutoCleanup
    ResultSettings.AutoBackup = ConfigFileSettings.AutoBackup
    ResultSettings.ServerVault = ConfigFileSettings.ServerVault

    #Resolve setting conflicts. If command line input has value then prioritize it. Otherwise use config.ini value.
    if CommandLineSettings.Input2DA != "":
        ResultSettings.Input2DA = CommandLineSettings.Input2DA
    else:
        ResultSettings.Input2DA = ConfigFileSettings.Input2DA

    if CommandLineSettings.InputBIC != "":
        ResultSettings.InputBIC = CommandLineSettings.InputBIC
    else:
        ResultSettings.InputBIC = ConfigFileSettings.InputBIC

    if CommandLineSettings.OutputJSON != "":
        ResultSettings.OutputJSON = CommandLineSettings.OutputJSON
    else:
        ResultSettings.OutputJSON = ConfigFileSettings.OutputJSON

    if CommandLineSettings.InputJSON != "":
        ResultSettings.InputJSON = CommandLineSettings.InputJSON
    else:
        ResultSettings.InputJSON = ConfigFileSettings.InputJSON

    if CommandLineSettings.OutputBIC != "":
        ResultSettings.OutputBIC = CommandLineSettings.OutputBIC
    else:
        ResultSettings.OutputBIC = ConfigFileSettings.OutputBIC

    #Evaluate if production mode is active. ReadSubDirectories and WriteInPlace only apply to Production operations
    #on server vaults which contain .bic files spread out into subdirectories.
    if CommandLineSettings.ProductionState and ConfigFileSettings.ProductionState:
        ResultSettings.ProductionState = true
        ResultSettings.ReadSubdirectories = true
        ResultSettings.WriteInPlace = true

    return ResultSettings

#expose results as Setting vars
#expose settinghasvalue():bool functions
#settings imports config and arguments
#all/most files import settings and reference settings 'final' vars directly
#cut down on function args?
#evaluate requirements refactored into separate modules, import settings, simply return bool/necessary value
#should settings all be packed into a Settings object/struct and passed into functions as a whole?
#editor calls GetSettingsPackage > that performs all settings gets and evaluations and returns Type/Object to be passed into all subsequent functions as needed