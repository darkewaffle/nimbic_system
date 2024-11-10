const GeneralHelp= """
Nimbic is a tool to programmatically modify Neverwinter Nights .bic files by exporting them to .json files.
It is primarily intended to apply character edits to server vaults / batches all at one time to retroactively enforce changes made in 2DA files.

This will cover the basics of operation. See https://github.com/darkewaffle/nimbic_system/blob/main/README.md for full documentation.
Please note that some of these values can also be specified in nimbic.ini to make executing commands more convenient.
"""

const ModeHelp = """
--mode
    File Operations
        bictojson = convert files from .bic to .json
        jsontobic = convert files from .json to .bic
        jsontohtml = create a .html character sheet from .json (requires a valid 2da directory)

    Character Operations
        addclassfeat    = grant a feat to a character at a specific class level (requires --feat, --class, --level)
        removeclassfeat = remove a feat from a character at a specific class level (requires --feat, --class, --level)
        addfeat         = grant a feat to a character (requires --feat, --level defaults to 1)
        removefeat      = remove a feat from a character (requires --feat, --level defaults to 1)
        alterclasshp    = increase or decrease HP granted by a class by the amount specified by --hp (requires --class, --hp defaults to 0)
        maxhp           = maximize the HP a character rolled at each level (requires a valid 2da directory)
        modifyability   = increase or decrease ability scores by the amount specified by --str, --dex, --con, --int, --wis, --cha
"""

const ArgumentHelp = """
Command Line Arguments
These values are input to specify what an operation will do or identify which chararacters it should affect.

    --class   = integer value representing the class index as found in classes.2da
                required for class operations, otherwise behaves like a filter

    --level   = integer value representing the 'character level' except for class operations where it is 'class level'
                specifies both the level an operation should be performed at as well as a requirement for it to be applied

    --race    = integer value representing the race index as found in racial_types.2da
                behaves like a filter to identify characters subject to an operation

    --subrace = text value representing the subrace value assigned to a character, do not input symbols/punctuation
                behaves like a filter to identify characters subject to an operation

    --feat    = integer value representing the feat index as found in feats.2da 

    --hp, --str, --dex, --con, --int, --wis, --cha all accept integers representing the amount by which they should be changed
"""

const DirectoryHelp = """
    --input    = represents the directory holding input files for an operation
    --output   = represents the directory an operation will write files to
    --input2da = directory where nimbic can read 2da files (only necessary for maxhp and jsontohtml modes)
    ** Note that directories and other advanced settings can be set in nimbic.ini instead **
"""

const ExampleHelp = """
Here are some simple examples.

Convert characters from .bic to .json
    nimbic.exe --mode:bictojson --input:"C:\Users\Name\Neverwinter Nights\localvault" --output:"C:\Users\Name\Documents\NWN\BICtoJSON"

Grant Toughness to Wizards at Level 5...
    nimbic.exe --mode:addclassfeat --input:"C:\Users\Name\Documents\NWN\BICtoJSON" --output:"C:\Users\Name\Documents\NWN\BICtoJSON" --class:10 --level:5 --feat:40

Maximize HP at each level using a set of 2da files to find the appropriate amount for each class...
    nimbic.exe --mode:maxhp --input:"C:\Users\Name\Documents\NWN\BICtoJSON" --output:"C:\Users\Name\Documents\NWN\BICtoJSON" --input2da:"C:\Users\Name\Documents\NWN\2da"

Generate .html character sheets from .json files...
    nimbic.exe --mode:jsontohtml --input:"C:\Users\Name\Documents\NWN\BICtoJSON" --output:"C:\Users\Name\Documents\NWN\BICtoHTML"

Convert .json files back into playable character .bic files...
    nimbic.exe --mode:jsontobic --input:"C:\Users\Name\Documents\NWN\BICtoJSON" --output:"C:\Users\Name\Documents\NWN\JSONtoBIC"


** Note that the below examples omit the directories. These can be set in nimbic.ini for convenience **

Remove Deflect Arrows from monks at level 2...
    nimbic.exe --mode:removeclassfeat --class:5 --level:2 --feat:8

Grant Epic Skill Focus Discipline to all characters at level 21...
    nimbic.exe --mode:addfeat --level:21 --feat:592

Grant 4 additional HP per level to Barbarian Dwarves...
    nimbic.exe --mode:alterclasshp --class:0 --race:0 --hp:4

Grant 2 strength and -2 intelligence to all Fighters
    nimbic.exe --mode:modifyability --class:4 --str:2 --int:-2
"""

proc DisplayHelp*() =
    echo GeneralHelp
    echo ModeHelp
    echo ArgumentHelp
    echo DirectoryHelp
    echo ExampleHelp