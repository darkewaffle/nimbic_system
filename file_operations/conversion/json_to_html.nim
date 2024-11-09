import std/[ json]

import ../[interface_io]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]

import html/[html_formatting, table_abilities, table_classes, table_deityalign, table_levels, table_namerace, table_spellbook]

const
    FullPageContainer = "pagecontainer"
    CoreStructureCSS = """
        /*  Structural Elements  */
        * {  box-sizing: border-box; }
        html, body, .pagecontainer {width: 100%; background-color: #00101F; margin: 0px; padding: 0px;}
        .pagecontainer {width: 75%;}
        body {padding: 50px;}
        .pagecontainer{display: flex; flex-direction: row; flex-wrap: wrap; gap: 30px 40px; margin: auto;}
        """
    CoreAppearanceCSS = """
        /*  Visual Style  */
        span, table {font-family: Helvetica, Verdana, Tahoma, sans-serif; font-size: 1em; text-align: center; color: #B4ADB4;}
        table, th, td {border: 2px dotted #696267; border-collapse: collapse;}
        td, th {padding: 3px;}
        """

    TopLeftContainerClass = "topleft"
    TopLeftContainerStyle = "{flex: 1 0 60%; display: flex; flex-direction: column; row-gap: 40px;}"


proc JSONtoHTML*(InputFile: string, OperationSettings: SettingsPackage)

proc JSONtoHTML*(InputFile: string, OperationSettings: SettingsPackage) =
    echo "JSON to HTML beginning " & $InputFile

    var
        CharacterJSON = parseFile(InputFile)

        NameRace = BuildTableNameRace(CharacterJSON)
        NameRaceCSS = BuildTableNameRaceCSS()

        DeityAlign = BuildTableDeityAlign(CharacterJSON)
        DeityAlignCSS = BuildTableDeityAlignCSS()

        Classes = BuildClassTable(CharacterJSON)
        ClassesCSS = BuildClassTableCSS(CharacterJSON)

        Abilities = BuildAbilityTable(CharacterJSON)
        AbilitieCSS = BuildAbilityTableCSS()

        LevelTable = BuildLevelTable(CharacterJSON)
        LevelTableCSS = BuildLevelTableCSS()

        Spellbook = BuildSpellbook(CharacterJSON)
        SpellbookCSS = BuildSpellbookCSS()

        TopLeftContainer = WrapDiv(NameRace & DeityAlign & Classes, TopLeftContainerClass)
        TopLeftContainerCSS = MakeStyleClass(TopLeftContainerClass, TopLeftContainerStyle)

        PageContainer = WrapDiv(TopLeftContainer & Abilities & LevelTable & Spellbook, FullPageContainer)

        CompleteCSS = CoreStructureCSS & CoreAppearanceCSS & TopLeftContainerCSS & NameRaceCSS & DeityAlignCSS & ClassesCSS & AbilitieCSS & LevelTableCSS & SpellbookCSS

        StyleHeader = WrapHead(WrapStyle(CompleteCSS))
        FinalHTML = WrapHTML(StyleHeader & WrapBody(PageContainer))

    var WritePath = CreateOutputPathHTML(InputFile, OperationSettings.OutputHTML, false)
    writeFile(WritePath, FinalHTML)
    
    echo "JSON to HTML complete"


