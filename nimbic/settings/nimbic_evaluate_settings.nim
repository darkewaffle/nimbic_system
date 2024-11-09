import /[nimbic_commandline, nimbic_config, object_settingspackage]

proc GetOperationSettings*(): SettingsPackage

proc GetOperationSettings*(): SettingsPackage =
    var CommandLineSettings = GetSettingsFromCommandLine()
    var ConfigFileSettings = GetSettingsFromConfigFile()
    var ResultSettings = NewSettingsPackage()

    #Set values that can only come from command line.
    ResultSettings.Mode = CommandLineSettings.Mode
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
    ResultSettings.RestoreFrom = CommandLineSettings.RestoreFrom

    #Set values that can only come from config.ini
    ResultSettings.ExpectSqlite = ConfigFileSettings.ExpectSqlite
    ResultSettings.OverwriteHTML = ConfigFileSettings.OverwriteHTML
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

    if CommandLineSettings.OutputHTML != "":
        ResultSettings.OutputHTML = CommandLineSettings.OutputHTML
    else:
        ResultSettings.OutputHTML = ConfigFileSettings.OutputHTML

    #Evaluate if production mode is active. ReadSubDirectories and WriteInPlace only apply to Production operations
    #on server vaults which contain .bic files spread out into subdirectories.
    if CommandLineSettings.ProductionState and ConfigFileSettings.ProductionState:
        ResultSettings.ProductionState = true
        ResultSettings.ReadSubdirectories = true
        ResultSettings.WriteInPlace = true
        ResultSettings.InputBIC = ConfigFileSettings.ServerVault
        ResultSettings.OutputJSON = ConfigFileSettings.ServerVault
        ResultSettings.InputJSON = ConfigFileSettings.ServerVault
        ResultSettings.OutputBIC = ConfigFileSettings.ServerVault

    return ResultSettings