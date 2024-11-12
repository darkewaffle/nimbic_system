import std/[os, parseopt, paths, strutils]
import /[object_settingspackage, string_cleanup]

proc GetSettingsFromCommandLine*(): SettingsPackage

proc GetSettingsFromCommandLine*(): SettingsPackage =
    var 
        CommandLineArguments = initOptParser(quoteShellCommand(commandLineParams()))
        CommandLineSettings = NewSettingsPackage()

    for kind, key, val in CommandLineArguments.getopt():
        case kind
            #Not supported. cmdArgument are not preceded by - or -- and are usually handled by the order in which they are input.
            #cmdShortOptions are single characters preceded by a -.
            of cmdArgument, cmdShortOption:
                discard

            #LongOption are prefixed with --, short option prefixed with -
            of cmdLongOption:

                case key
                    #Operational parameters
                    of "mode":
                        CommandLineSettings.Mode = val

                    of "feat":
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
                    of "race":
                        CommandLineSettings.Race = parseInt(val)
                        CommandLineSettings.RaceActive = true

                    of "subrace", "sub":
                        CommandLineSettings.Subrace = val
                        CommandLineSettings.SubraceActive = true

                    of "class":
                        CommandLineSettings.Class = parseInt(val)
                        CommandLineSettings.ClassActive = true

                    of "level", "lvl":
                        CommandLineSettings.Level = parseInt(val)
                        CommandLineSettings.LevelActive = true


                    #Input/output parameters
                    #Assign to both Input settings since it could be either depending on the chosen mode.
                    #Modes only use one Input directory per operation so this will not have any adverse effects.
                    of "input":
                        CommandLineSettings.InputBIC = Path(CleanDirectoryName(val))
                        CommandLineSettings.InputJSON = Path(CleanDirectoryName(val))

                    #Assign to all Output settings since it could be any of them depending on the chosen mode.
                    #Modes only use one Output directory per operation so this will not have any adverse effects.
                    of "output":
                        CommandLineSettings.OutputBIC = Path(CleanDirectoryName(val))
                        CommandLineSettings.OutputJSON = Path(CleanDirectoryName(val))
                        CommandLineSettings.OutputHTML = Path(CleanDirectoryName(val))

                    of "2da":
                        CommandLineSettings.Input2DA = Path(CleanDirectoryName(val))

                    of "production", "prod":
                        CommandLineSettings.ProductionState = true

                    of "restorefrom":
                        CommandLineSettings.RestoreFrom = Path(CleanDirectoryName(val))

                    else:
                        discard
            else:
                discard
    return CommandLineSettings