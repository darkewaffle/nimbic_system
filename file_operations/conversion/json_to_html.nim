import std/[json, strutils]

import ../[interface_2da, interface_io]
import ../../nimbic/[echo_feedback]
import ../../nimbic/settings/[object_settingspackage]
import ../../bic_as_json_operations/[interface_get]
import html/[css_generators, header_title, html_generators, html_tag_wrappers, table_abilities, table_classes, table_deityalign, table_levels, table_namerace, table_spellbook]

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
proc BuildFileName(CharacterJSON: JsonNode): string

proc JSONtoHTML*(InputFile: string, OperationSettings: SettingsPackage) =
    echo "JSON to HTML beginning " & $InputFile

    var
        CharacterJSON = parseFile(InputFile)

        PageTitle = BuildTitle(CharacterJSON)

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

        Header = WrapHead(PageTitle & WrapStyle(CompleteCSS))
        FinalHTML = WrapHTML(Header & WrapBody(PageContainer))

    var WritePath = CreateOutputPathHTML(InputFile, OperationSettings.OutputHTML, false, BuildFileName(CharacterJSON))
    writeFile(WritePath, FinalHTML)

    echo "JSON to HTML complete"


proc BuildFileName(CharacterJSON: JsonNode): string =
    var
        FileName = GetCharacterFullName(CharacterJSON)
        ClassesAndLevels = GetCharacterClasses(CharacterJSON)

    FileName = replace(FileName, " ", "") & "_"

    for i in ClassesAndLevels.low .. ClassesAndLevels.high:
        FileName = FileName & GetClassLabel(ClassesAndLevels[i][0], Shortened = true) & $ClassesAndLevels[i][1]
        if i != ClassesAndLevels.high:
            FileName = FileName & "_"
    return FileName