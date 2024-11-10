import std/[os, parseopt, paths, strutils]
import /[object_settingspackage]

proc GetSettingsFromCommandLine*(): SettingsPackage

proc GetSettingsFromCommandLine*(): SettingsPackage =
    var 
        CommandLineArguments = initOptParser(quoteShellCommand(commandLineParams()))
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

                    of "str":
                        CommandLineSettings.AbilityInput[0] = parseInt(val)
                    of "dex":
                        CommandLineSettings.AbilityInput[1] = parseInt(val)
                    of "con":
                        CommandLineSettings.AbilityInput[2] = parseInt(val)
                    of "int":
                        CommandLineSettings.AbilityInput[3] = parseInt(val)
                    of "wis":
                        CommandLineSettings.AbilityInput[4] = parseInt(val)
                    of "cha":
                        CommandLineSettings.AbilityInput[5] = parseInt(val)

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
                        CommandLineSettings.InputBIC = Path(val)
                        CommandLineSettings.InputJSON = Path(val)

                    #Assign to all Output settings since it could be any of them depending on the chosen mode.
                    #Modes only use one Output directory per operation so this will not have any adverse effects.
                    of "output":
                        CommandLineSettings.OutputBIC = Path(val)
                        CommandLineSettings.OutputJSON = Path(val)
                        CommandLineSettings.OutputHTML = Path(val)

                    of "input2da", "2da":
                        CommandLineSettings.Input2DA = Path(val)

                    of "production", "prod":
                        CommandLineSettings.ProductionState = true

                    of "restorefrom", "rf":
                        CommandLineSettings.RestoreFrom = Path(val)

                    else:
                        discard
            else:
                discard
    return CommandLineSettings