#Contains each setting from both command line and config.ini relevant to how the program operates.
#'Active' vars indicate if a value has been input from the command line. This is done since an uninitialized value
#for an int would be 0 but 0 is also a valid identifier for some values (like race 0 = dwarf, class 0 = barbarian).
#So Class = 0 and ClassActive = false means no class, whereas class = 0 and ClassActive = true means barbarian.

type SettingsPackage* = object
    Mode*: string
    Race*: int
    RaceActive*: bool
    Subrace*: string
    SubraceActive*: bool
    Class*: int
    ClassActive*: bool
    Level*: int
    LevelActive*: bool
    Feat*: int
    FeatActive*: bool
    AbilityInput*: array[0..5, int]
    HPInput*: int

    Input2DA*: string
    InputBIC*: string
    OutputJSON*: string
    InputJSON*: string
    OutputBIC*: string
    ExpectSqlite*: bool

    ProductionState*: bool
    AutoCleanup*: bool
    AutoBackup*: bool
    ReadSubdirectories*: bool
    WriteInPlace*: bool
    ServerVault*: string

proc EchoSettings*(Input: SettingsPackage) =
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

    echo "Input2DA       " & $Input.Input2DA
    echo "InputBIC       " & $Input.InputBIC
    echo "OutputJSON     " & $Input.OutputJSON
    echo "InputJSON      " & $Input.InputJSON
    echo "OutputBIC      " & $Input.OutputBIC
    echo "ExpectSqlite   " & $Input.ExpectSqlite

    echo "ProductionState    " & $Input.ProductionState
    echo "AutoCleanup        " & $Input.AutoCleanup
    echo "AutoBackup         " & $Input.AutoBackup
    echo "ReadSubdirectories " & $Input.ReadSubdirectories
    echo "WriteInPlace       " & $Input.WriteInPlace
    echo "ServerVault        " & $Input.ServerVault