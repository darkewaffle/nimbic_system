#Contains each setting from both command line and config.ini relevant to how the program operates.
#'Active' vars indicate if a value has been input from the command line. This is done since an uninitialized value
#for an int would be 0 but 0 is also a valid identifier for some values (like race 0 = dwarf, class 0 = barbarian).
#So Class = 0 and ClassActive = false means no class, whereas class = 0 and ClassActive = true means barbarian.

type
    LevelRange* = range[1 .. 40]
    ClassRange* = range[0 .. 254]
    RaceRange* = range[0 .. 254]
    FeatRange* = range[0 .. high(int)]

type SettingsPackage* = object
    #Command line only
    Mode*: string
    Race*: RaceRange
    RaceActive*: bool
    Subrace*: string
    SubraceActive*: bool
    Class*: ClassRange
    ClassActive*: bool
    Level*: LevelRange
    LevelActive*: bool
    Feat*: FeatRange
    FeatActive*: bool
    AbilityInput*: array[0..5, int]
    HPInput*: int
    RestoreFrom*: string

    #Config file only
    ExpectSqlite*: bool
    OverwriteHTML*: bool
    AutoCleanup*: bool
    AutoBackup*: bool
    ServerVault*: string

    #Directories can be input from command line or config.
    #Evaluated and assigned in nimbic_evaluate_settings
    Input2DA*: string
    InputBIC*: string
    OutputJSON*: string
    InputJSON*: string
    OutputBIC*: string
    OutputHTML*: string

    #Production settings that only apply to Server Vault operations
    ProductionState*: bool
    ReadSubdirectories*: bool
    WriteInPlace*: bool


proc NewSettingsPackage*(): SettingsPackage =
    #Ranges do not initialize with a value and must be assigned manually to create a new object.
    var NewSettings = SettingsPackage(Race: 0, Class: 0, Level: 1, Feat: 0)

    NewSettings.Mode = ""
    #NewSettings.Race = 0
    NewSettings.RaceActive = false
    NewSettings.Subrace = ""
    NewSettings.SubraceActive = false
    #NewSettings.Class = 0
    NewSettings.ClassActive = false
    #NewSettings.Level = 1
    NewSettings.LevelActive = false
    #NewSettings.Feat = 0
    NewSettings.FeatActive = false
    NewSettings.AbilityInput = [0, 0, 0, 0, 0, 0]
    NewSettings.HPInput = 0
    NewSettings.RestoreFrom = ""

    NewSettings.ExpectSqlite = false
    NewSettings.OverwriteHTML = false
    NewSettings.AutoCleanup = false
    NewSettings.AutoBackup = false
    NewSettings.ServerVault = ""

    NewSettings.Input2DA = ""
    NewSettings.InputBIC = ""
    NewSettings.OutputJSON = ""
    NewSettings.InputJSON = ""
    NewSettings.OutputBIC = ""
    NewSettings.OutputHTML = ""

    NewSettings.ProductionState = false
    NewSettings.ReadSubdirectories = false
    NewSettings.WriteInPlace = false

    return NewSettings

proc EchoSettings*(Input: SettingsPackage) =
    echo "Command Line   "
    echo "Mode           " & $Input.Mode
    echo "Race           " & $Input.Race
    echo "RaceActive     " & $Input.RaceActive
    echo "Subrace        " & $Input.Subrace
    echo "SubraceActive  " & $Input.SubraceActive
    echo "Class          " & $Input.Class
    echo "ClassActive    " & $Input.ClassActive
    echo "Level          " & $Input.Level
    echo "LevelActive    " & $Input.LevelActive
    echo "Feat           " & $Input.Feat
    echo "FeatActive     " & $Input.FeatActive
    echo "AbilityInput   " & $Input.AbilityInput
    echo "HPInput        " & $Input.HPInput
    echo "RestoreFrom    " & $Input.RestoreFrom
    echo ""

    echo "Config file    "
    echo "ExpectSqlite   " & $Input.ExpectSqlite
    echo "OverwriteHTML  " & $Input.OverwriteHTML
    echo "AutoCleanup    " & $Input.AutoCleanup
    echo "AutoBackup     " & $Input.AutoBackup
    echo "ServerVault    " & $Input.ServerVault
    echo ""

    echo "Directory eval "
    echo "Input2DA       " & $Input.Input2DA
    echo "InputBIC       " & $Input.InputBIC
    echo "OutputJSON     " & $Input.OutputJSON
    echo "InputJSON      " & $Input.InputJSON
    echo "OutputBIC      " & $Input.OutputBIC
    echo "OutputHTML     " & $Input.OutputHTML
    echo ""

    echo "Production Settings"
    echo "ProductionState    " & $Input.ProductionState
    echo "ReadSubdirectories " & $Input.ReadSubdirectories
    echo "WriteInPlace       " & $Input.WriteInPlace