import nim_bic_editor_argument_parse
import nimbic_config

proc ReconcileCommandLineArgumentsAndConfigSettings*()
proc EvaluateInputDirectory()
proc EvaluateOutputDirectory()
proc Evaluate2DADirectory()
proc EvaluateProduction()

var ProductionState*: bool

proc ReconcileCommandLineArgumentsAndConfigSettings*() =
  EvaluateInputDirectory()
  EvaluateOutputDirectory()
  Evaluate2DADirectory()
  EvaluateProduction()

proc EvaluateInputDirectory() =
  if InputDirectory != DefaultInputDirectory:
    ConfigInputBIC = InputDirectory
    ConfigInputJSON = InputDirectory

proc EvaluateOutputDirectory() =
  if OutputDirectory != DefaultOutputDirectory:
    ConfigOutputBIC = OutputDirectory
    ConfigOutputJSON = OutputDirectory

proc Evaluate2DADirectory() =
  if Input2DA != DefaultInput2DA:
    ConfigInput2DA = Input2DA

proc EvaluateProduction() =
  ProductionState = InputProduction and ConfigProduction
  if ProductionState:
    ConfigInputBIC = ConfigServerVault
    ConfigInputJSON = ConfigServerVault
    ConfigOutputBIC = ConfigServerVault
    ConfigOutputJSON = ConfigServerVault