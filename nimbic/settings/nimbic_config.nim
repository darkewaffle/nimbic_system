import std/[os, paths, strutils]
import /[nimbic_config_template, object_settingspackage]
import ../[echo_feedback]

proc GetSettingsFromConfigFile*(): SettingsPackage
proc ReadConfigurationFile(FileName: string): seq[seq[string]]
proc CleanConfigurationValues(DirtyConfig: var seq[seq[string]])
proc AssignConfigurationValuesToSettingsPackage(ConfigurationSettings: seq[seq[string]]): SettingsPackage

const
    ConfigurationFileName = "nimbic.ini"
    KeyInputBIC = "inputbic"
    KeyOutputJSON = "outputjson"
    KeyInputJSON = "inputjson"
    KeyOutputBIC = "outputbic"
    KeyOutputHTML = "outputhtml"
    KeyOverwriteHTML = "overwritehtml"
    KeyInput2DA = "2dadir"
    KeySqlite = "sqlite"
    KeyProduction = "production"
    KeyAutoCleanup = "autocleanup"
    KeyAutoBackup= "autobackup"
    KeyServerVault = "servervault"

proc GetSettingsFromConfigFile*(): SettingsPackage =
    if fileExists(ConfigurationFileName):
        var TextFromConfig = ReadConfigurationFile(ConfigurationFileName)
        CleanConfigurationValues(TextFromConfig)
        return AssignConfigurationValuesToSettingsPackage(TextFromConfig)
    else:
        EchoNotice("No configuration file found. Creating " & getAppDir() & """\""" & ConfigurationFileName)
        writeFile(ConfigurationFileName, ConfigurationFileStarterText)
        return NewSettingsPackage()

proc ReadConfigurationFile(FileName: string): seq[seq[string]] =
    var TextFromConfigFile: seq[seq[string]]
    for line in FileName.lines:
        if line.isEmptyOrWhiteSpace() or line.startsWith("#"):
            discard
        else:
            TextFromConfigFile.add(split(line,"=",1))
    return TextFromConfigFile

proc CleanConfigurationValues(DirtyConfig: var seq[seq[string]]) =
    for i in DirtyConfig.low .. DirtyConfig.high:
        DirtyConfig[i][1] = replace(DirtyConfig[i][1], "\"", "")
        DirtyConfig[i][1] = replace(DirtyConfig[i][1], "'", "")
        if endsWith(DirtyConfig[i][1], """\"""):
            removeSuffix(DirtyConfig[i][1], """\""")

proc AssignConfigurationValuesToSettingsPackage(ConfigurationSettings: seq[seq[string]]): SettingsPackage =
    var ConfigFileSettings = NewSettingsPackage()
    for i in ConfigurationSettings.low .. ConfigurationSettings.high:
        case ConfigurationSettings[i][0]:
            of KeyInputBIC:
                ConfigFileSettings.InputBIC =  Path(ConfigurationSettings[i][1])

            of KeyOutputJSON:
                ConfigFileSettings.OutputJSON =  Path(ConfigurationSettings[i][1])

            of KeyInputJSON:
                ConfigFileSettings.InputJSON =  Path(ConfigurationSettings[i][1])

            of KeyOutputBIC:
                ConfigFileSettings.OutputBIC =  Path(ConfigurationSettings[i][1])

            of KeyOutputHTML:
                ConfigFileSettings.OutputHTML =  Path(ConfigurationSettings[i][1])

            of KeyOverwriteHTML:
                ConfigFileSettings.OverwriteHTML = ($ConfigurationSettings[i][1]).parseBool

            of KeyInput2DA:
                ConfigFileSettings.Input2DA = Path(ConfigurationSettings[i][1])

            of KeySqlite:
                ConfigFileSettings.ExpectSqlite = ($ConfigurationSettings[i][1]).parseBool

            of KeyProduction:
                ConfigFileSettings.ProductionState = ($ConfigurationSettings[i][1]).parseBool

            of KeyAutoCleanup:
                ConfigFileSettings.AutoCleanup = ($ConfigurationSettings[i][1]).parseBool

            of KeyAutoBackup:
                ConfigFileSettings.AutoBackup = ($ConfigurationSettings[i][1]).parseBool

            of KeyServerVault:
                ConfigFileSettings.ServerVault = Path(ConfigurationSettings[i][1])

            else:
                discard
    return ConfigFileSettings