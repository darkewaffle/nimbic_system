import std/[json]

import /[html_formatting]
import ../../[interface_2da]
import ../../../nimbic/[echo_feedback]
import ../../../bic_as_json_operations/[interface_get]

const
    TableClass = "classes"
    TableStyle = "{flex: 1 0 auto;}"
    TDClass = "classesTD"

proc BuildClassTable*(CharacterJSON: JsonNode): string
proc BuildClassTableCSS*(CharacterJSON: JsonNode): string

proc BuildClassTable*(CharacterJSON: JsonNode): string =
    var 
        ClassesAndLevels = GetCharacterClasses(CharacterJSON)
        Table: seq[string]
        HTML: string

    for i in ClassesAndLevels.low .. ClassesAndLevels.high:
        Table.add(GetClassLabel(ClassesAndLevels[i][0], true) & " - " & $ClassesAndLevels[i][1])

    HTML = HTML & CreateTableRow(Table, TDClass)

    return WrapTable(HTML, TableClass)

proc BuildClassTableCSS*(CharacterJSON: JsonNode): string =
    var CharacterNumberOfClasses = GetCharacterClasses(CharacterJSON).high + 1
    return MakeStyleClass(TableClass, TableStyle) & 
           WidthStyle(TableClass, TDClass, CharacterNumberOfClasses)