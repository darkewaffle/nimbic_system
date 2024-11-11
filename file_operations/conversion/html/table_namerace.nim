import std/[json]
import /[css_generators, html_generators, html_tag_wrappers]
import ../../[interface_2da]
import ../../../bic_as_json_operations/[interface_get]

const
    TableColumns= ["Name", "Race", "Subrace"]
    TableClass = "namerace"
    TableStyle = "{flex: 1 0 auto;}"
    THClass = "nameraceTH"
    THStyle = "{width: 33%;}"

proc BuildTableNameRace*(CharacterJSON: JsonNode): string
proc BuildTableNameRaceCSS*(): string

proc BuildTableNameRace*(CharacterJSON: JsonNode): string =
    var Table: seq[array[3, string]]
    var HTML: string

    HTML = CreateTableHeader(TableColumns, THClass)
    Table.add([GetCharacterFullName(CharacterJSON), GetRaceLabel(GetCharacterRace(CharacterJSON), true), GetCharacterSubRace(CharacterJSON)])

    for i in Table.low .. Table.high:
        HTML = HTML & CreateTableRow(Table[i])

    return WrapTable(HTML, TableClass)

proc BuildTableNameRaceCSS*(): string =
    return MakeStyleClass(TableClass, TableStyle) & 
           MakeStyleClass(THClass, THStyle)