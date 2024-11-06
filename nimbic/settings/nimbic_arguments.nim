import std/[os, parseopt, strutils]

import /[object_settingspackage]
from ../../json_operations/ability_modify import AbilityIndex

proc AssignArgumentsToVariables*(CommandLineArguments: var OptParser)
proc GetSettingsFromCommandLine*(): SettingsPackage

#Variables for input from arguments
const
    DefaultMode* = "defaultmode"
    DefaultRace* = -1
    DefaultSubrace* = "defaultsubrace"
    DefaultClass* = -1
    DefaultLevel* = -1
    DefaultFeatID* = -1
    DefaultAbilityInput* = [0, 0, 0, 0, 0, 0]
    DefaultHPInput* = 0
var
    Mode* = DefaultMode
    RequiredRace* = DefaultRace
    RequiredSubrace* = DefaultSubrace
    RequiredClass* = DefaultClass
    RequiredLevel* = DefaultLevel
    FeatID* = DefaultFeatID
    AbilityInput* = DefaultAbilityInput
    HPInput* = DefaultHPInput

#Variables for input relating to file input/output
const
    DefaultInputDirectory* = "defaultinput"
    DefaultOutputDirectory* = "defaultoutput"
    DefaultInput2DA* = "default2da"
    DefaultInputProduction* = false
var
    ArgInputDirectory* = DefaultInputDirectory
    ArgOutputDirectory* = DefaultOutputDirectory
    ArgInput2DA* = DefaultInput2DA
    ArgInputProduction* = DefaultInputProduction


proc GetSettingsFromCommandLine*(): SettingsPackage =
    var 
        CommandLineArguments = initOptParser(quoteShellCommand(commandLineParams()))
        #CommandLineSettings: SettingsPackage
        CommandLineSettings = NewSettingsPackage()

    for kind, key, val in CommandLineArguments.getopt():
        case kind
            #Not supported. These are arguments not preceded by - or -- and are usually handled by the order in which they are input.
            of cmdArgument:
                discard

            #LongOption are prefixed with --, short option prefixed with -
            of cmdLongOption, cmdShortOption:

                case key
                    #Operational parameters
                    of "mode", "m":
                        CommandLineSettings.Mode = val

                    of "feat", "f":
                        CommandLineSettings.Feat = parseInt(val)
                        CommandLineSettings.FeatActive = true

                    #AbilityIndex returns a 0-5 value for each ability abbreviation.
                    of "str", "dex", "con", "int", "wis", "cha":
                        CommandLineSettings.AbilityInput[AbilityIndex(key)] = parseInt(val)

                    of "hp":
                        CommandLineSettings.HPInput = parseInt(val)


                    #Character requirements / filters
                    of "race", "r":
                        CommandLineSettings.Race = parseInt(val)
                        CommandLineSettings.RaceActive = true

                    of "subrace", "sub":
                        CommandLineSettings.Subrace = val
                        CommandLineSettings.SubraceActive = true

                    of "class", "c":
                        CommandLineSettings.Class = parseInt(val)
                        CommandLineSettings.ClassActive = true

                    of "level", "lvl":
                        CommandLineSettings.Level = parseInt(val)
                        CommandLineSettings.LevelActive = true


                    #Input/output parameters
                    #Assign to both Input settings since it could be either depending on the chosen mode.
                    #Modes only use one Input directory per operation so this will not have any adverse effects.
                    of "input":
                        CommandLineSettings.InputBIC = val
                        CommandLineSettings.InputJSON = val

                    #Assign to all Output settings since it could be any of them depending on the chosen mode.
                    #Modes only use one Output directory per operation so this will not have any adverse effects.
                    of "output":
                        CommandLineSettings.OutputBIC = val
                        CommandLineSettings.OutputJSON = val
                        CommandLineSettings.OutputHTML = val

                    of "input2da", "2da":
                        CommandLineSettings.Input2DA = val

                    of "production", "prod":
                        CommandLineSettings.ProductionState = true

                    of "restorefrom", "rf":
                        CommandLineSettings.RestoreFrom = val

                    else:
                        discard
            else:
                discard
    return CommandLineSettings


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
                        ArgInputDirectory = val

                    of "output", "od":
                        ArgOutputDirectory = val

                    of "input2da", "i2da":
                        ArgInput2DA = val

                    of "production", "prod":
                        ArgInputProduction = true

                    else:
                        discard
            else:
                discard