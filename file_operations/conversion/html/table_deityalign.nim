import std/[json]

import /[css_generators, html_generators, html_tag_wrappers]
import ../../../nimbic/[echo_feedback]
import ../../../bic_as_json_operations/[interface_get]

const
    TableColumns = ["Deity", "Good / Evil", "Lawful / Chaotic"]
    TableClass = "deityalign"
    TableStyle = "{flex: 1 0 auto;}"
    THClass = "deityalignTH"
    THStyle = "{width: 33%;}"

proc BuildTableDeityAlign*(CharacterJSON: JsonNode): string
proc BuildTableDeityAlignCSS*(): string

proc BuildTableDeityAlign*(CharacterJSON: JsonNode): string =
    var Table: seq[array[3, string]]
    var HTML: string

    HTML = CreateTableHeader(TableColumns, THClass)
    Table.add([GetCharacterDeity(CharacterJSON), GetCharacterGoodEvilDescription(CharacterJSON), GetCharacterLawfulChaoticDescription(CharacterJSON)])

    for i in Table.low .. Table.high:
        HTML = HTML & CreateTableRow(Table[i])

    return WrapTable(HTML, TableClass)

proc BuildTableDeityAlignCSS*(): string =
    return MakeStyleClass(TableClass, TableStyle) & 
           MakeStyleClass(THClass, THStyle)