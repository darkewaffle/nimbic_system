import std/[json]

import /[html_formatting]
import ../../[interface_2da]
import ../../../nimbic/[echo_feedback]
import ../../../bic_as_json_operations/[interface_get]

const
    Container = "spellbook"
    ContainerStyle = "{flex: 1 1 100%; display: flex; flex-direction: row; flex-wrap: wrap; gap: 20px 40px;}"
    TitleClass = "spellbookheader"
    TitleStyle = " {flex: 1 1 100%; border-bottom: 2px dotted #696267;}"
    TableClass = "spellbooktable"
    TableStyle = "{flex:1 1 15%; margin-bottom: auto; border: 0px;}"
    TDClass = "spellbookcell"
    TDStyle = "{border-left: 0px; border-top: 0px; border-right: 0px;}"

proc BuildSpellbook*(CharacterJSON: JsonNode): string
proc BuildSpellbookCSS*(): string
proc SpellbookColumnName(SpellLevel: int): string

proc BuildSpellbook*(CharacterJSON: JsonNode): string =
    var
        ClassesAndLevels = GetCharacterClasses(CharacterJSON)
        HTML: string

    for i in ClassesAndLevels.low .. ClassesAndLevels.high:
        if GetClassSpellbookRestricted(ClassesAndLevels[i][0]):
            var ClassSpellBook = WrapSpan(GetClassLabel(ClassesAndLevels[i][0]) & " Spellbook", TitleClass)
            var ClassSpells = GetCharacterSpellsFromClassAsNames(CharacterJSON, ClassesAndLevels[i][0])
            for j in ClassSpells.low .. ClassSpells.high:
                var LevelSpells = ClassSpells[j]
                LevelSpells.insert(SpellbookColumnName(j), 0)
                ClassSpellBook = ClassSpellBook & MakeTDTable(LevelSpells, TableClass, TDClass, 1, false)
            HTML = HTML & ClassSpellBook

    return WrapDiv(HTML, Container)

proc BuildSpellbookCSS*(): string =
    return MakeStyleClass(Container, ContainerStyle) & 
           MakeStyleClass(TitleClass, TitleStyle) & 
           MakeStyleClass(TableClass, TableStyle) & 
           MakeStyleClass(TDClass, TDStyle)

proc SpellbookColumnName(SpellLevel: int): string =
    if SpellLevel > 0:
        return "Level " & $SpellLevel
    else:
        return "Cantrips"