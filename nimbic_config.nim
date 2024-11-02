import std/[os, strutils]
import nimbic_config_template
import echo_feedback
import object_settingspackage

proc GetSettingsFromConfigFile*()
proc GetSettingsPackageFromConfigFile*(): SettingsPackage
proc ReadConfigurationFile()
proc CleanseConfigurationValues()
proc AssignConfigurationValues()
proc AssignConfigurationValuesToSettingsPackage(): SettingsPackage
proc EchoConfigurationValues()

const
    ConfigurationFileName = "nimbic.ini"
    KeyInputBIC = "inputbic"
    KeyOutputJSON = "outputjson"
    KeyInputJSON = "inputjson"
    KeyOutputBIC = "outputbic"
    KeyInput2DA = "2dadir"
    KeySqlite = "sqlite"
    KeyProduction = "production"
    KeyAutoCleanup = "autocleanup"
    KeyAutoBackup= "autobackup"
    KeyServerVault = "servervault"

var
    ConfigurationSettings: seq[seq[string]]
    ConfigInputBIC*: string
    ConfigOutputJSON*: string
    ConfigInputJSON*: string
    ConfigOutputBIC*: string
    ConfigInput2DA*: string
    ConfigSqlite*: bool
    ConfigProduction*: bool
    ConfigAutoCleanup*: bool
    ConfigAutoBackup*: bool
    ConfigServerVault*: string

proc GetSettingsFromConfigFile*() =
  if fileExists(ConfigurationFileName):
    ReadConfigurationFile()
    CleanseConfigurationValues()
    AssignConfigurationValues()
    #EchoConfigurationValues()
  else:
    EchoNotice("No configuration file found. Creating " & getAppDir() & """\""" & ConfigurationFileName)
    writeFile(ConfigurationFileName, ConfigurationFileStarterText)

proc GetSettingsPackageFromConfigFile*(): SettingsPackage =
  if fileExists(ConfigurationFileName):
    ReadConfigurationFile()
    CleanseConfigurationValues()
    return AssignConfigurationValuesToSettingsPackage()
  else:
    EchoNotice("No configuration file found. Creating " & getAppDir() & """\""" & ConfigurationFileName)
    writeFile(ConfigurationFileName, ConfigurationFileStarterText)
    return NewSettingsPackage()

proc ReadConfigurationFile() =
  for line in ConfigurationFileName.lines:
    if line.isEmptyOrWhiteSpace() or line.startsWith("#"):
      discard
    else:
      ConfigurationSettings.add(split(line,"=",1))

proc CleanseConfigurationValues() =
  for i in ConfigurationSettings.low .. ConfigurationSettings.high:
    ConfigurationSettings[i][1] = replace(ConfigurationSettings[i][1], "\"", "")
    ConfigurationSettings[i][1] = replace(ConfigurationSettings[i][1], "'", "")
    if endsWith(ConfigurationSettings[i][1], """\"""):
      removeSuffix(ConfigurationSettings[i][1], """\""")

proc AssignConfigurationValuesToSettingsPackage(): SettingsPackage =
#    var ConfigFileSettings: SettingsPackage
    var ConfigFileSettings = NewSettingsPackage()
    for i in ConfigurationSettings.low .. ConfigurationSettings.high:
        case ConfigurationSettings[i][0]:
            of KeyInputBIC:
                ConfigFileSettings.InputBIC = $ConfigurationSettings[i][1]

            of KeyOutputJSON:
                ConfigFileSettings.OutputJSON = $ConfigurationSettings[i][1]

            of KeyInputJSON:
                ConfigFileSettings.InputJSON = $ConfigurationSettings[i][1]

            of KeyOutputBIC:
                ConfigFileSettings.OutputBIC = $ConfigurationSettings[i][1]

            of KeyInput2DA:
                ConfigFileSettings.Input2DA = $ConfigurationSettings[i][1]

            of KeySqlite:
                ConfigFileSettings.ExpectSqlite = ($ConfigurationSettings[i][1]).parseBool

            of KeyProduction:
                ConfigFileSettings.ProductionState = ($ConfigurationSettings[i][1]).parseBool

            of KeyAutoCleanup:
                ConfigFileSettings.AutoCleanup = ($ConfigurationSettings[i][1]).parseBool

            of KeyAutoBackup:
                ConfigFileSettings.AutoBackup = ($ConfigurationSettings[i][1]).parseBool

            of KeyServerVault:
                ConfigFileSettings.ServerVault = $ConfigurationSettings[i][1]

            else:
              discard
    return ConfigFileSettings

proc AssignConfigurationValues() =
  for i in ConfigurationSettings.low .. ConfigurationSettings.high:
    case ConfigurationSettings[i][0]:
      of KeyInputBIC:
        ConfigInputBIC = $ConfigurationSettings[i][1]

      of KeyOutputJSON:
        ConfigOutputJSON = $ConfigurationSettings[i][1]

      of KeyInputJSON:
        ConfigInputJSON = $ConfigurationSettings[i][1]

      of KeyOutputBIC:
        ConfigOutputBIC = $ConfigurationSettings[i][1]

      of KeyInput2DA:
        ConfigInput2DA = $ConfigurationSettings[i][1]

      of KeySqlite:
        ConfigSqlite = ($ConfigurationSettings[i][1]).parseBool

      of KeyProduction:
        ConfigProduction = ($ConfigurationSettings[i][1]).parseBool

      of KeyAutoCleanup:
        ConfigAutoCleanup = ($ConfigurationSettings[i][1]).parseBool

      of KeyAutoBackup:
        ConfigAutoBackup = ($ConfigurationSettings[i][1]).parseBool

      of KeyServerVault:
        ConfigServerVault = $ConfigurationSettings[i][1]

      else:
        discard

proc EchoConfigurationValues() =
  for i in ConfigurationSettings.low .. ConfigurationSettings.high:
    echo ConfigurationSettings[i]
  echo "inbic   " & $ConfigInputBIC
  echo "outjson " & $ConfigOutputJSON
  echo "injson  " & $ConfigInputJSON
  echo "outbic  " & $ConfigOutputBIC
  echo "in2da   " & $ConfigInput2DA
  echo "sqlite  " & $ConfigSqlite
  echo "cleanup " & $ConfigAutoCleanup
  echo "backup  " & $ConfigAutoBackup
  echo "prod    " & $ConfigProduction
  echo "svault  " & $ConfigServerVault