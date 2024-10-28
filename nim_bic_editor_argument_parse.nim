import std/[parseopt, strutils]
from ability_modify import AbilityIndex

proc AssignArgumentsToVariables*(CommandLineArguments: var OptParser)

#Variables for input from arguments
const
  DefaultMode* = "test"
  DefaultRace* = -1
  DefaultSubrace* = "defaultsubrace"
  DefaultClass* = 255
  DefaultLevel* = -1
  DefaultFeatID* = 9999
var
  Mode* = DefaultMode
  RequiredRace* = DefaultRace
  RequiredSubrace* = DefaultSubrace
  RequiredClass* = DefaultClass
  RequiredLevel* = DefaultLevel
  FeatID* = DefaultFeatID
  AbilityInput* = [0, 0, 0, 0, 0, 0]
  HPInput* = 0

#Variables for input relating to file input/output
const
  DefaultInputDirectory* = "defaultinput"
  DefaultOutputDirectory* = "defaultoutput"
  DefaultInput2DA* = "default2da"
var
  InputDirectory* = DefaultInputDirectory
  OutputDirectory* = DefaultOutputDirectory
  Input2DA* = DefaultInput2DA


proc AssignArgumentsToVariables*(CommandLineArguments: var OptParser) =
  for kind, key, val in CommandLineArguments.getopt():
    case kind
      of cmdArgument:
        #Not supported. These are arguments not preceded by - or -- and are usually handled by the order in which they are input.
        discard

      #LongOption are prefixed with --, short option prefixed with -
      of cmdLongOption, cmdShortOption:
        case key

        #Operational parameters
          of "mode", "m":
            Mode = val

          of "featid", "feat", "f":
            FeatID = parseInt(val)

          of "str", "dex", "con", "int", "wis", "cha":
            AbilityInput[AbilityIndex(key)] = parseInt(val)

          of "hp":
            HPInput = parseint(val)


        #Character requirements / filters
          of "race", "r":
            RequiredRace = parseInt(val)

          of "subrace", "sub", "sr":
            RequiredSubrace = val

          of "class", "c":
            RequiredClass = parseInt(val)

          of "level", "lvl", "l":
            RequiredLevel = parseInt(val)


        #Input/output parameters
          of "input", "id":
            InputDirectory = val

          of "output", "od":
            OutputDirectory = val

          of "input2da", "i2da":
            Input2DA = val

          else:
            discard
      else:
        discard