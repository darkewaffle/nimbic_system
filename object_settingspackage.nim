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