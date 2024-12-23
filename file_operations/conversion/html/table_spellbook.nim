import std/[json]
import /[css_generators, html_generators, html_tag_wrappers]
import ../../[interface_2da]
import ../../../bic_as_json_operations/[interface_get]

const
    Container = "spellbook"
    ContainerStyle = "{flex: 1 1 100%; display: flex; flex-direction: row; flex-wrap: wrap; gap: 20px 3%;}"
    TitleClass = "spellbookheader"
    TitleStyle = " {flex: 1 1 100%; border-bottom: 2px dotted #696267;}"
    TableClass = "spellbooktable"
    TableStyle = "{flex:1 1 15%; margin-bottom: auto; border: 0px;}"
    TDClass = "spellbookcell"
    TDStyle = "{border-left: 0px; border-top: 0px; border-right: 0px;}"

var
    SpellbookFlexCSS: string

proc BuildSpellbook*(CharacterJSON: JsonNode): string
proc BuildSpellbookForClass(CharacterJSON: JsonNode, ClassID: int): string 
proc BuildSpellbookCSS*(): string
proc SpellLevelColumnName(SpellLevel: int): string

proc BuildSpellbook*(CharacterJSON: JsonNode): string =
    SpellbookFlexCSS = ""

    var
        ClassesAndLevels = GetCharacterClasses(CharacterJSON)
        HTML: string

    for i in ClassesAndLevels.low .. ClassesAndLevels.high:
        if GetClassSpellbookRestricted(ClassesAndLevels[i][0]):
            var ClassSpellBook = BuildSpellbookForClass(CharacterJSON, ClassesAndLevels[i][0])
            HTML = HTML & ClassSpellBook
    return WrapDiv(HTML, Container)

proc BuildSpellbookForClass(CharacterJSON: JsonNode, ClassID: int): string =
    var
        ClassLabel = GetClassLabel(ClassID)
        ClassSpellBook = WrapSpan(ClassLabel & " Spellbook", TitleClass)
        ClassSpells = GetCharacterSpellsFromClassAsNames(CharacterJSON, ClassID)

    for i in ClassSpells.low .. ClassSpells.high:
        var LevelSpells = ClassSpells[i]
        LevelSpells.insert(SpellLevelColumnName(i), 0)
        ClassSpellBook = ClassSpellBook & MakeTable(LevelSpells, TableClass & " " & ClassLabel, TDClass, 1, false)

    SpellbookFlexCSS = SpellbookFlexCSS & MakeStyleFlex(ClassLabel, ClassSpells.high + 1, 5, 1, 1)
    return ClassSpellBook

proc BuildSpellbookCSS*(): string =
    return MakeStyleClass(Container, ContainerStyle) & 
           MakeStyleClass(TitleClass, TitleStyle) & 
           MakeStyleClass(TableClass, TableStyle) & 
           MakeStyleClass(TDClass, TDStyle) &
           SpellbookFlexCSS

proc SpellLevelColumnName(SpellLevel: int): string =
    if SpellLevel > 0:
        return "Level " & $SpellLevel
    else:
        return "Cantrips"