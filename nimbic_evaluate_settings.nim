import nimbic_arguments
import nimbic_config

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

#expose results as Setting vars
#expose settinghasvalue():bool functions
#settings imports config and arguments
#all/most files import settings and reference settings 'final' vars directly
#cut down on function args?
#evaluate requirements refactored into separate modules, import settings, simply return bool/necessary value
#should settings all be packed into a Settings object/struct and passed into functions as a whole?
#editor calls GetSettingsPackage > that performs all settings gets and evaluations and returns Type/Object to be passed into all subsequent functions as needed